<template>
  <div class="gacha-container">
    <h2>空间补给舱</h2>
    <p>消耗星币获取珍稀资源与舰员</p>

    <div class="gacha-options">
      <div class="card">
        <h3>普通补给舱</h3>
        <p>价格：100 星币</p>
        <button @click="handleGacha('normal')">开启 (100)</button>
      </div>

      <div class="card">
        <h3>高级补给舱</h3>
        <p>价格：500 星币</p>
        <button @click="handleGacha('advanced')" class="advanced">开启 (500)</button>
      </div>
    </div>

    <div v-if="resultMsg" class="result">
      <p>{{ resultMsg }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import request from '../api/request';
import { useUser } from '../status/useUser';

const { user, updateCoins } = useUser();
const resultMsg = ref('');

const handleGacha = async (type) => {
  if (!user.value) {
    alert('请先登录！');
    return;
  }

  const res = await request.post('/gacha', null, {
    params: { userId: user.value.id, type: type }
  });

  if (res.code === 0) {
    resultMsg.value = res.msg;
    // 【关键】后端返回最新的金币余额并更新
    if (res.data && res.data.newCoins !== undefined) {
      updateCoins(res.data.newCoins);
    }
  } else {
    alert(res.msg);
  }
};
</script>

<style scoped>
.gacha-container { text-align: center; padding: 20px; }
.gacha-options { display: flex; justify-content: center; gap: 20px; margin-top: 30px; }
.card { border: 1px solid #00d4ff; padding: 20px; border-radius: 10px; width: 200px; }
button { margin-top: 10px; padding: 10px 20px; cursor: pointer; }
.advanced { background: gold; border: none; font-weight: bold; }
.result { margin-top: 30px; color: #00d4ff; font-size: 1.2em; }
</style>