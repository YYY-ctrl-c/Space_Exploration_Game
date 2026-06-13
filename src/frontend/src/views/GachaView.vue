<template>
  <div class="gacha-page">
    <div class="stars"></div>

    <div class="header">
      <div class="logo">🎁</div>
      <h1>空间补给舱</h1>
      <p>开启补给获取舰员与珍稀资源</p>

      <div class="coin-panel">
        当前星币：<span>{{ user?.coins || 0 }}</span>
      </div>
    </div>

    <div class="gacha-grid">
      <div class="gacha-card normal">
        <div class="icon">📦</div>
        <h3>普通补给舱</h3>
        <p>获取基础资源与舰员</p>
        <div class="price">💰 100</div>
        <button @click="handleGacha('normal')">开启补给</button>
      </div>

      <div class="gacha-card advanced">
        <div class="icon">✨</div>
        <h3>高级补给舱</h3>
        <p>更高概率获得稀有奖励</p>
        <div class="price">💰 500</div>
        <button class="gold-btn" @click="handleGacha('advanced')">开启高级补给</button>
      </div>
    </div>

    <div v-if="resultMsg" class="modal-overlay" @click="closeResult">
      <div class="result-panel" @click.stop>
        <h3>🎉 获得奖励</h3>
        <p class="result-text">{{ resultMsg }}</p>
        <button class="confirm-btn" @click="closeResult">确 定</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user, updateCoins } = useUser()
const resultMsg = ref('')

const handleGacha = async (type) => {
  if (!user.value) {
    alert('请先登录')
    return
  }

  try {
    const res = await request.post('/gacha', null, {
      params: {
        userId: user.value.id,
        type: type
      }
    })

    if (res.code === 0) {
      resultMsg.value = res.msg
      if (res.data && res.data.newCoins !== undefined) {
        updateCoins(res.data.newCoins)
      }
    } else {
      alert(res.msg)
    }
  } catch (err) {
    console.error(err)
    alert('服务器连接失败')
  }
}

// 关闭弹窗
const closeResult = () => {
  resultMsg.value = ''
}
</script>

<style scoped>
.gacha-page {
  min-height: 100vh;
  padding: 40px 20px;
  position: relative;
  overflow: hidden;
  background: radial-gradient(circle at top, #163d73 0%, #08111f 45%, #02050b 100%);
  display: flex;
  flex-direction: column;
  justify-content: transform;
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

/* 标题 */
.header {
  position: relative;
  z-index: 10;
  text-align: center;
  margin-bottom: 30px;
}

.logo {
  width: 70px;
  height: 70px;
  margin: auto;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.6);
}

.header h1 {
  margin-top: 15px;
  color: white;
  font-size: 32px;
  letter-spacing: 3px;
  text-shadow: 0 0 10px #00d4ff, 0 0 20px #00d4ff;
}

.header p {
  margin-top: 8px;
  color: #8ea9c7;
  letter-spacing: 1px;
  font-size: 14px;
}

/* 星币面板 */
.coin-panel {
  display: inline-block;
  margin-top: 15px;
  padding: 10px 24px;
  border-radius: 30px;
  background: rgba(11, 23, 44, 0.85);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(0, 212, 255, 0.25);
  color: #a4c1e4;
  font-size: 15px;
}

.coin-panel span {
  color: #00d4ff;
  font-size: 20px;
  font-weight: bold;
}

/* 补给舱卡片区域：改用 Flex 居中，锁死卡片宽度防止横向过大 */
.gacha-grid {
  position: relative;
  z-index: 10;
  display: flex;
  justify-content: center;
  gap: 35px;
  max-width: 800px;
  margin: 10px auto;
  width: 100%;
}

.gacha-card {
  width: 300px; /* 固定卡片宽度，黄金比例 */
  padding: 35px 25px;
  border-radius: 20px;
  text-align: center;
  background: rgba(10, 18, 35, 0.8);
  backdrop-filter: blur(15px);
  transition: 0.35s cubic-bezier(0.25, 1, 0.5, 1);
}

.gacha-card:hover {
  transform: translateY(-8px);
}

.gacha-card .icon {
  font-size: 54px;
  margin-bottom: 15px;
}

.gacha-card h3 {
  color: white;
  font-size: 22px;
  margin-bottom: 8px;
}

.gacha-card p {
  color: #8fa7c2;
  font-size: 14px;
  margin-bottom: 25px;
}

/* 普通与高级卡片边框发光特效 */
.normal {
  border: 1px solid rgba(0, 212, 255, 0.3);
  box-shadow: 0 4px 20px rgba(0, 212, 255, 0.1);
}
.normal:hover {
  box-shadow: 0 12px 30px rgba(0, 212, 255, 0.25);
}

.advanced {
  border: 1px solid rgba(255, 193, 7, 0.35);
  box-shadow: 0 4px 20px rgba(255, 193, 7, 0.1);
}
.advanced:hover {
  box-shadow: 0 12px 30px rgba(255, 193, 7, 0.3);
}

/* 价格 */
.price {
  font-size: 26px;
  font-weight: bold;
  margin-bottom: 25px;
  color: #ffd54f;
}

/* 按钮基础样式 */
button {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 12px;
  cursor: pointer;
  color: white;
  font-size: 16px;
  font-weight: bold;
  transition: 0.25s;
}

button:hover {
  transform: scale(1.02);
  filter: brightness(1.1);
}

.normal button {
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  box-shadow: 0 4px 15px rgba(0, 102, 255, 0.3);
}

.gold-btn {
  background: linear-gradient(135deg, #ffe082, #ffb300);
  color: #1c1300;
  box-shadow: 0 4px 15px rgba(255, 179, 0, 0.3);
}

/* 【全新核心功能】全局全屏遮罩层 */
.modal-overlay {
  position: fixed;
  inset: 0;
  background: rgba(2, 5, 11, 0.85);
  backdrop-filter: blur(8px);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 999; /* 保证在最顶层 */
}

/* 抽卡结果弹窗主体 */
.result-panel {
  width: 90%;
  max-width: 420px;
  padding: 35px 25px;
  text-align: center;
  border-radius: 20px;
  background: rgba(16, 28, 48, 0.95);
  border: 1px solid rgba(0, 212, 255, 0.4);
  box-shadow: 0 0 35px rgba(0, 212, 255, 0.35);
  /* 游戏级华丽切入动画 */
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

.result-text {
  color: white;
  font-size: 18px;
  line-height: 1.6;
  background: rgba(255, 255, 255, 0.05);
  padding: 15px;
  border-radius: 10px;
  margin-bottom: 25px;
  border: 1px solid rgba(255, 255, 255, 0.05);
}

/* 弹窗里面的关闭确认按钮 */
.confirm-btn {
  width: 140px;
  padding: 10px;
  background: linear-gradient(135deg, #00d4ff, #0066ff);
  border-radius: 8px;
  font-size: 15px;
}

/* 手机自适应 */
@media (max-width: 768px) {
  .gacha-grid {
    flex-direction: column;
    align-items: center;
    gap: 20px;
  }
  .gacha-card {
    width: 100%;
    max-width: 320px;
  }
}
</style>