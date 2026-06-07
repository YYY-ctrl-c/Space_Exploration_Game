<template>
  <div class="explore-container">
    <h2>星域探索</h2>

    <div class="site-list">
      <h3>选择目标星域：</h3>
      <button @click="selectedLoc = 1" :class="{active: selectedLoc === 1}">太阳系前哨站 (消耗10)</button>
      <button @click="selectedLoc = 2" :class="{active: selectedLoc === 2}">天狼星资源带 (消耗20)</button>
      <button @click="selectedLoc = 3" :class="{active: selectedLoc === 3}">猎户座遗迹 (消耗35)</button>
    </div>

    <div class="crew-select">
      <h3>指派舰员：</h3>
      <select v-model="selectedCrewId">
        <option v-for="crew in crewList" :key="crew.id" :value="crew.id">
          {{ crew.nickname }} (疲劳: {{ crew.fatigue }}/{{ crew.fatigueMax }})
        </option>
      </select>
    </div>

    <button class="start-btn" @click="startExplore" :disabled="!selectedCrewId || !selectedLoc">
      开始执行任务
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import request from '../api/request';
import { useUser } from '../status/useUser';

const { user, updateCoins } = useUser();// 获取 user 对象和 setUser 方法
const crewList = ref([]);
const selectedCrewId = ref(null);
const selectedLoc = ref(null);

// 获取舰员列表用于选择
const fetchCrews = async () => {
  const user = JSON.parse(localStorage.getItem('user'));
  const res = await request.get('/crew', { params: { userId: user.id } });
  crewList.value = res;
};

// 执行探索
const startExplore = async () => {
  const user = JSON.parse(localStorage.getItem('user'));
  // 这里增加加载状态处理更好
  const res = await request.post('/explore', null, {
    params: {
      userId: user.id,
      crewId: selectedCrewId.value,
      locId: selectedLoc.value
    }
  });

  if (res.code === 0) {
    // 成功展示具体奖励信息
    alert('探索报告:\n' + res.msg);
    updateCoins(res.data.newCoins);
    fetchCrews(); // 重新加载舰员状态
  } else {
    alert('探索失败: ' + res.msg);
  }
};

onMounted(fetchCrews);
</script>

<style scoped>
.site-list button { margin: 5px; padding: 10px; }
.active { background-color: #00d4ff; color: white; }
.start-btn { margin-top: 20px; padding: 15px 30px; width: 100%; }
</style>