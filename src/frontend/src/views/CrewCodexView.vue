<template>
  <div class="codex-container">
    <h2>舰员图鉴</h2>
    <div class="crew-grid">
      <div v-for="item in crewList" :key="item.id"
           :class="['crew-card', { 'locked': !item.isOwned }]">
        <img :src="item.icon" :alt="item.name" />
        <h3>{{ item.name }}</h3>
        <p v-if="item.isOwned">{{ item.description }}</p>
        <p v-else>??? (未招募)</p>
        <div class="rarity">稀有度: {{ item.rarity }}</div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import request from '../api/request';
import { useUser } from '../status/useUser';

const { user } = useUser();
const crewList = ref([]);

const fetchCrewList = async () => {
  // 假设后端接口返回一个数组
  const res = await request.get('/crew-codex', {
    params: { userId: user.value.id }
  });
  crewList.value = res;
};

onMounted(fetchCrewList);
</script>

<style scoped>
.codex-container { padding: 20px; }
.crew-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(150px, 1fr)); gap: 15px; }
.crew-card { border: 1px solid #ccc; padding: 10px; border-radius: 8px; text-align: center; background: #2a2a40; color: #fff; }

/* 关键：未招募的样式 */
.crew-card.locked {
  filter: grayscale(100%); /* 变灰 */
  opacity: 0.6;           /* 降低透明度 */
}

img { width: 80px; height: 80px; }
</style>