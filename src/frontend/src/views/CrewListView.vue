<template>
  <div class="crew-container">
    <h2>舰员指挥中心</h2>
    <div v-for="crew in crewList" :key="crew.id" class="crew-card">
      <p>代号：{{ crew.nickname }}</p>
      <p>状态：{{ crew.fatigue }}/{{ crew.fatigueMax }} (疲劳度)</p>
      <button @click="restCrew(crew.id)">补充能量</button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import request from '../api/request';

const crewList = ref([]);

// 获取舰员列表
const fetchCrews = async () => {
  const user = JSON.parse(localStorage.getItem('user'));
  const res = await request.get('/crew', { params: { userId: user.id } });
  crewList.value = res;
};

// 补充能量操作
const restCrew = async (crewId) => {
  const res = await request.post('/crew', null, {
    params: { crewId: crewId, supplyPower: 50 }
  });
  if (res.code === 0) {
    alert('能量补充完毕！');
    fetchCrews(); // 刷新数据
  }
};

onMounted(fetchCrews);
</script>

<style scoped>
.crew-card { border: 1px solid #444; padding: 10px; margin: 10px; border-radius: 8px; }
</style>