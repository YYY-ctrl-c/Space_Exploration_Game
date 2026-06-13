<template>
  <div class="crew-page">
    <div class="stars"></div>

    <div class="header">
      <div class="logo">👩‍🚀</div>
      <h1>舰员指挥中心</h1>
      <p>管理舰队成员与恢复状态</p>
    </div>

    <div class="crew-grid">
      <div
          v-for="crew in crewList"
          :key="crew.id"
          class="crew-card"
      >
        <div class="crew-avatar">
          <img
              :src="crew.icon"
              :alt="crew.name"
              onerror="this.src='/icons/default.png'"
          />
        </div>

        <h3>{{ crew.nickname }}</h3>

        <div class="fatigue-section">
          <div class="fatigue-label">疲劳度</div>
          <div class="fatigue-bar">
            <div
                class="fatigue-fill"
                :style="{ width: (crew.fatigue / crew.fatigueMax) * 100 + '%' }"
            ></div>
          </div>
          <div class="fatigue-text">
            {{ crew.fatigue }} / {{ crew.fatigueMax }}
          </div>
        </div>

        <div class="recovery-section">
          <select v-model="selectedItem[crew.id]">
            <option value="">选择恢复物品</option>
            <option
                v-for="item in getAvailableItems(crew)"
                :key="item.id"
                :value="item.id"
            >
              {{ item.name }} ×{{ item.amount }} （恢复{{ item.supplyPower }}）
            </option>
          </select>

          <button @click="restCrew(crew.id, selectedItem[crew.id])">
            补充能量
          </button>

          <button
              class="dismiss-btn"
              @click="openDismissConfirm(crew.id, crew.nickname)"
          >
            驱逐舰员
          </button>
        </div>
      </div>
    </div>

    <div v-if="confirmModal.show" class="modal-overlay" @click="confirmModal.show = false">
      <div class="result-panel danger-border" @click.stop>
        <h3>{{ confirmModal.title }}</h3>
        <div class="result-text">{{ confirmModal.msg }}</div>
        <div class="modal-buttons">
          <button class="confirm-btn danger-btn" @click="handleDismissConfirm">最终确定</button>
          <button class="cancel-btn" @click="confirmModal.show = false">取消</button>
        </div>
      </div>
    </div>

    <div v-if="alertModal.show" class="modal-overlay" @click="closeAlert">
      <div class="result-panel" @click.stop>
        <h3>{{ alertModal.title }}</h3>
        <div class="result-text center-text">{{ alertModal.msg }}</div>
        <button class="confirm-btn" @click="closeAlert">好的</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user } = useUser()
const crewList = ref([])
const items = ref([])
const selectedItem = ref({})

// 🌟 新增：弹窗控制响应式变量
const alertModal = ref({ show: false, title: '', msg: '' })
const confirmModal = ref({ show: false, title: '', msg: '', crewId: null, nickname: '' })

/* 🌟 新增：唤起内置提示弹窗 */
const showAlert = (title, msg) => {
  alertModal.value = { show: true, title, msg }
}
const closeAlert = () => {
  alertModal.value.show = false
}

/* 加载舰员 */
const fetchCrews = async () => {
  try {
    const res = await request.get('/crew', {
      params: { userId: user.value.id }
    })
    crewList.value = res || []
  } catch (err) {
    console.error(err)
    showAlert('📡 通信失败', '舰员数据加载失败，请检查网络链路')
  }
}

/* 加载恢复道具 */
const fetchItems = async () => {
  try {
    const itemsRes = await request.get('/items', {
      params: { userId: user.value.id }
    })
    const shopRes = await request.get('/shop')
    const powerMap = new Map()

    shopRes.forEach(s => {
      if (s.supplyPower > 0) {
        powerMap.set(s.id, s.supplyPower)
      }
    })

    items.value = itemsRes
        .filter(i => powerMap.has(i.id))
        .map(i => ({
          ...i,
          supplyPower: powerMap.get(i.id)
        }))
  } catch (err) {
    console.error(err)
  }
}

/* 获取可用恢复物品 */
const getAvailableItems = (crew) => {
  return items.value.filter(item => {
    if (item.amount <= 0) return false
    if (item.id === 16) return true
    if (item.id >= 1 && item.id <= 15 && item.id === crew.crewId) return true
    return false
  })
}

/* 恢复舰员 */
const restCrew = async (crewId, itemId) => {
  if (!itemId) {
    showAlert('💡 操作提示', '请先在下拉列表中选择要消耗的恢复物品')
    return
  }
  try {
    const res = await request.post('/crew', null, {
      params: { crewId, itemId }
    })
    if (res.code === 0) {
      showAlert('🔋 能量充能', '核心能量补充成功，疲劳值已下降！')
      selectedItem.value[crewId] = null
      await fetchCrews()
      await fetchItems()
    } else {
      showAlert('❌ 充能失败', '恢复未成功：' + res.msg)
    }
  } catch (err) {
    console.error(err)
    showAlert('📡 链接断开', '与母舰服务器连接失败')
  }
}

/* 🌟 修改：触发自定义驱逐确认弹窗 */
const openDismissConfirm = (crewId, nickname) => {
  confirmModal.value = {
    show: true,
    title: '⚠️ 核心解雇警报',
    msg: `确定要驱逐舰员 [${nickname}] 吗？\n此操作将从星际数据库中永久抹除该舰员的所有档案！`,
    crewId,
    nickname
  }
}

/* 🌟 修改：最终执行驱逐 */
const handleDismissConfirm = async () => {
  const { crewId, nickname } = confirmModal.value
  confirmModal.value.show = false // 关闭确认框

  try {
    const res = await request.post('/crew/dismiss', null, {
      params: {
        userId: user.value.id,
        crewId: crewId
      }
    })

    if (res.code === 0) {
      showAlert('✨ 驱逐完毕', `舰员 [${nickname}] 已成功解除契约，并安全驱逐出舰队。`)
      await fetchCrews()
    } else {
      showAlert('❌ 操作受阻', '驱逐失败：' + res.msg)
    }
  } catch (err) {
    console.error(err)
    showAlert('📡 链接断开', '与母舰服务器连接失败')
  }
}

/* 页面初始化 */
onMounted(async () => {
  if (!user.value) return
  await fetchCrews()
  await fetchItems()
})
</script>

<style scoped>
.crew-page {
  min-height: 100vh;
  padding: 40px;
  position: relative;
  overflow: hidden;
  background: radial-gradient(circle at top, #163d73 0%, #08111f 45%, #02050b 100%);
}

.stars {
  position: absolute;
  inset: 0;
  pointer-events: none;
  background-image:
      radial-gradient(2px 2px at 50px 80px, #fff, transparent),
      radial-gradient(2px 2px at 180px 150px, #fff, transparent),
      radial-gradient(2px 2px at 320px 60px, #fff, transparent),
      radial-gradient(2px 2px at 520px 200px, #fff, transparent),
      radial-gradient(2px 2px at 760px 100px, #fff, transparent);
  background-size: 900px 450px;
  opacity: 0.45;
  animation: starMove 60s linear infinite;
}

@keyframes starMove {
  from { transform: translateY(0); }
  to { transform: translateY(-450px); }
}

.header {
  position: relative;
  z-index: 10;
  text-align: center;
  margin-bottom: 40px;
}

.logo {
  width: 90px;
  height: 90px;
  margin: auto;
  border-radius: 50%;
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 42px;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.6);
}

.header h1 {
  margin-top: 18px;
  color: white;
  font-size: 38px;
  letter-spacing: 3px;
  text-shadow: 0 0 10px #00d4ff, 0 0 20px #00d4ff;
}

.header p {
  margin-top: 10px;
  color: #8ea9c7;
  letter-spacing: 2px;
}

.crew-grid {
  position: relative;
  z-index: 10;
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 20px;
  max-width: 1000px;
  margin: 0 auto;
  width: 100%;
}

.crew-card {
  padding: 20px 15px;
  border-radius: 16px;
  background: rgba(10, 18, 35, 0.75);
  backdrop-filter: blur(14px);
  border: 1px solid rgba(0, 212, 255, 0.15);
  text-align: center;
  transition: 0.35s;
}

.crew-card:hover {
  transform: translateY(-6px);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.25);
}

.crew-avatar {
  width: 70px !important;
  height: 70px !important;
  overflow: hidden;
  margin: 0 auto 14px auto;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  box-shadow: 0 0 15px rgba(0, 212, 255, 0.3);
}

.crew-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.crew-card h3 {
  color: white;
  margin-bottom: 15px;
  font-size: 18px;
}

.fatigue-section {
  margin-bottom: 15px;
  background: rgba(255, 255, 255, 0.02);
  padding: 10px;
  border-radius: 10px;
}

.fatigue-label {
  color: #9db6d5;
  margin-bottom: 6px;
  font-size: 13px;
}

.fatigue-bar {
  width: 100%;
  height: 8px;
  border-radius: 10px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.08);
}

.fatigue-fill {
  height: 100%;
  border-radius: 10px;
  background: linear-gradient(90deg, #00d4ff, #00ff95);
  transition: 0.5s;
}

.fatigue-text {
  margin-top: 6px;
  color: #ffffff;
  font-weight: bold;
  font-size: 13px;
}

.recovery-section {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

select {
  width: 100%;
  padding: 10px;
  border-radius: 10px;
  border: 1px solid rgba(0, 212, 255, 0.2);
  background: rgba(255, 255, 255, 0.06);
  color: white;
  outline: none;
  font-size: 13px;
}

select option {
  background: #08111f;
  color: white;
}

button {
  width: 100%;
  padding: 10px;
  border: none;
  border-radius: 10px;
  cursor: pointer;
  font-weight: bold;
  color: white;
  font-size: 14px;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  transition: 0.3s;
  box-shadow: 0 4px 12px rgba(0, 102, 255, 0.2);
}

button:hover {
  transform: scale(1.02);
  box-shadow: 0 0 20px rgba(0, 212, 255, 0.5);
}

button:active {
  transform: scale(0.98);
}

.dismiss-btn {
  background: rgba(255, 77, 79, 0.12);
  border: 1px solid rgba(255, 77, 79, 0.4);
  color: #ff4d4f;
  box-shadow: none;
}

.dismiss-btn:hover {
  background: #ff4d4f;
  color: white;
  box-shadow: 0 0 15px rgba(255, 77, 79, 0.6);
  transform: scale(1.02);
}

/* ======================== 🌟 全新科幻风弹窗组件样式 ======================== */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(2, 5, 11, 0.85);
  backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 999;
}

.result-panel {
  width: 90%;
  max-width: 420px;
  padding: 30px 20px;
  text-align: center;
  border-radius: 20px;
  background: rgba(16, 28, 48, 0.95);
  border: 1px solid rgba(0, 212, 255, 0.4);
  box-shadow: 0 0 35px rgba(0, 212, 255, 0.35);
  animation: popIn 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* 驱逐危险操作特殊红框 */
.danger-border {
  border: 1px solid rgba(255, 77, 79, 0.5) !important;
  box-shadow: 0 0 35px rgba(255, 77, 79, 0.25) !important;
}

@keyframes popIn {
  from { transform: scale(0.85); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

.result-panel h3 {
  color: #ffd54f;
  margin-bottom: 18px;
  font-size: 24px;
  letter-spacing: 2px;
}

.danger-border h3 {
  color: #ff4d4f !important;
}

.result-text {
  color: #e2f1ff;
  font-size: 15px;
  line-height: 1.6;
  background: rgba(255, 255, 255, 0.04);
  padding: 16px;
  border-radius: 12px;
  margin-bottom: 22px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  text-align: left;
  white-space: pre-line;
}

.center-text {
  text-align: center !important;
}

.modal-buttons {
  display: flex;
  gap: 15px;
  justify-content: center;
}

.modal-buttons button {
  width: 120px !important;
}

.confirm-btn {
  background: linear-gradient(135deg, #00d4ff, #0066ff) !important;
  box-shadow: 0 4px 15px rgba(0, 102, 255, 0.3) !important;
}

.danger-btn {
  background: linear-gradient(135deg, #ff7875, #ff4d4f) !important;
  box-shadow: 0 4px 15px rgba(255, 77, 79, 0.3) !important;
}

.cancel-btn {
  background: rgba(255, 255, 255, 0.1) !important;
  border: 1px solid rgba(255, 255, 255, 0.2) !important;
  color: #cbd5e1 !important;
  box-shadow: none !important;
}

.cancel-btn:hover {
  background: rgba(255, 255, 255, 0.2) !important;
}

@media (max-width: 768px) {
  .crew-page { padding: 20px; }
  .header h1 { font-size: 28px; }
  .crew-grid {
    grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
    gap: 15px;
  }
}
</style>