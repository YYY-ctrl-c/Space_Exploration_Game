<template>
  <div class="explore-page">
    <div class="stars"></div>

    <div class="header">
      <div class="logo">🌌</div>
      <h1>星域探索中心</h1>
      <p>指派舰员执行深空任务</p>
    </div>

    <div class="explore-panel">
      <div class="section">
        <h3>选择目标星域</h3>
        <div class="location-grid">
          <div
              class="location-card"
              :class="{ active: selectedLoc === 1 }"
              @click="selectedLoc = 1"
          >
            <h4>☀️ 太阳系前哨站</h4>
            <p>探索消耗：10</p>
          </div>

          <div
              class="location-card"
              :class="{ active: selectedLoc === 2 }"
              @click="selectedLoc = 2"
          >
            <h4>⭐ 天狼星资源带</h4>
            <p>探索消耗：20</p>
          </div>

          <div
              class="location-card"
              :class="{ active: selectedLoc === 3 }"
              @click="selectedLoc = 3"
          >
            <h4>🛰 猎户座遗迹</h4>
            <p>探索消耗：35</p>
          </div>
        </div>
      </div>

      <div class="section">
        <h3>指派舰员</h3>
        <select v-model="selectedCrewId">
          <option :value="null">请选择舰员</option>
          <option
              v-for="crew in crewList"
              :key="crew.id"
              :value="crew.id"
          >
            {{ crew.nickname }} （疲劳: {{ crew.fatigue }} / {{ crew.fatigueMax }}）
          </option>
        </select>
      </div>

      <button
          class="start-btn"
          @click="startExplore"
          :disabled="!selectedCrewId || !selectedLoc"
      >
        🚀 开始执行任务
      </button>
    </div>

    <div v-if="reportMsg" class="modal-overlay" @click="closeReport">
      <div class="result-panel" @click.stop>
        <h3>📊 探索报告</h3>
        <div class="result-text">{{ reportMsg }}</div>
        <button class="confirm-btn" @click="closeReport">接收报告</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user, updateCoins } = useUser()
const crewList = ref([])
const selectedCrewId = ref(null)
const selectedLoc = ref(null)

// 🌟 新增：控制弹窗显示的响应式变量
const reportMsg = ref('')

/* 加载舰员 */
const fetchCrews = async () => {
  if (!user.value) return
  try {
    const res = await request.get('/crew', {
      params: { userId: user.value.id }
    })
    crewList.value = res || []
  } catch (err) {
    console.error(err)
    alert('舰员加载失败')
  }
}

/* 开始探索 */
const startExplore = async () => {
  if (!selectedCrewId.value) {
    alert('请选择舰员')
    return
  }
  if (!selectedLoc.value) {
    alert('请选择探索区域')
    return
  }

  try {
    const res = await request.post('/explore', null, {
      params: {
        userId: user.value.id,
        crewId: selectedCrewId.value,
        locId: selectedLoc.value
      }
    })

    if (res.code === 0) {
      // 🌟 将原先的 alert 修改为赋值给弹窗变量
      reportMsg.value = res.msg

      if (res.data && res.data.newCoins !== undefined) {
        updateCoins(res.data.newCoins)
      }
      await fetchCrews()
    } else {
      alert('探索失败：' + res.msg)
    }
  } catch (err) {
    console.error(err)
    alert('服务器连接失败')
  }
}

// 🌟 新增：关闭报告弹窗的方法
const closeReport = () => {
  reportMsg.value = ''
}

onMounted(() => {
  fetchCrews()
})
</script>

<style scoped>
.explore-page {
  min-height: 100vh;
  padding: 40px;
  position: relative;
  overflow: hidden;
  background: radial-gradient(circle at top, #163d73 0%, #08111f 45%, #02050b 100%);
}

/* 星空背景 */
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

/* 顶部标题 */
.header {
  position: relative;
  z-index: 10;
  text-align: center;
  margin-bottom: 45px;
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

/* 主面板 */
.explore-panel {
  position: relative;
  z-index: 10;
  max-width: 1000px;
  margin: auto;
  padding: 35px;
  border-radius: 25px;
  background: rgba(10, 18, 35, 0.72);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(0, 212, 255, 0.15);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.08);
}

.section {
  margin-bottom: 35px;
}

.section h3 {
  color: white;
  margin-bottom: 18px;
  font-size: 22px;
}

/* 星域选择 */
.location-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 20px;
}

.location-card {
  padding: 22px;
  border-radius: 18px;
  cursor: pointer;
  transition: 0.35s;
  background: rgba(255, 255, 255, 0.04);
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.location-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.2);
}

.location-card.active {
  border: 1px solid #00d4ff;
  background: rgba(0, 212, 255, 0.12);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.4);
}

.location-card h4 {
  color: white;
  margin-bottom: 10px;
}

.location-card p {
  color: #9db6d5;
}

/* 下拉框 */
select {
  width: 100%;
  padding: 14px;
  border-radius: 14px;
  border: 1px solid rgba(0, 212, 255, 0.2);
  background: rgba(255, 255, 255, 0.06);
  color: white;
  font-size: 15px;
  outline: none;
}

select option {
  background: #08111f;
  color: white;
}

/* 按钮 */
.start-btn {
  width: 100%;
  padding: 16px;
  border: none;
  border-radius: 16px;
  cursor: pointer;
  font-size: 17px;
  font-weight: bold;
  color: white;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  box-shadow: 0 0 20px rgba(0, 212, 255, 0.3);
  transition: 0.3s;
}

.start-btn:hover:not(:disabled) {
  transform: translateY(-2px) scale(1.02);
  box-shadow: 0 0 30px rgba(0, 212, 255, 0.7);
}

.start-btn:disabled {
  cursor: not-allowed;
  opacity: 0.5;
}

/* 🌟 全局弹窗全屏暗化遮罩层 */
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

/* 🌟 华丽报告弹窗主体 */
.result-panel {
  width: 90%;
  max-width: 460px;
  padding: 35px 25px;
  text-align: center;
  border-radius: 20px;
  background: rgba(16, 28, 48, 0.95);
  border: 1px solid rgba(0, 212, 255, 0.4);
  box-shadow: 0 0 35px rgba(0, 212, 255, 0.35);
  /* 炫酷入场缩放动画 */
  animation: popIn 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes popIn {
  from { transform: scale(0.85); opacity: 0; }
  to { transform: scale(1); opacity: 1; }
}

.result-panel h3 {
  color: #ffd54f;
  margin-bottom: 20px;
  font-size: 26px;
  letter-spacing: 2px;
  text-shadow: 0 0 10px rgba(255, 213, 79, 0.4);
}

/* 🌟 报告文本展示框 */
.result-text {
  color: #e2f1ff;
  font-size: 16px;
  line-height: 1.7;
  background: rgba(255, 255, 255, 0.04);
  padding: 20px;
  border-radius: 12px;
  margin-bottom: 25px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  text-align: left; /* 报告一般较长，左对齐更易于阅读 */
  white-space: pre-line; /* 【关键】保留文本中的 \n 自动换行 */
}

/* 弹窗确认按钮 */
.confirm-btn {
  width: 150px;
  padding: 12px;
  border: none;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  border-radius: 10px;
  color: white;
  font-weight: bold;
  font-size: 15px;
  cursor: pointer;
  transition: 0.2s;
  box-shadow: 0 4px 15px rgba(0, 102, 255, 0.3);
}

.confirm-btn:hover {
  transform: scale(1.03);
  filter: brightness(1.1);
}

/* 手机适配 */
@media (max-width: 768px) {
  .explore-page { padding: 20px; }
  .explore-panel { padding: 20px; }
  .header h1 { font-size: 28px; }
}
</style>