<template>
  <div class="home-container">
    <div class="hero">
      <h1>欢迎回来，指挥官 {{ commanderName }}</h1>
      <p>状态：当前指挥中心运作正常</p>
    </div>

    <div class="dashboard">
      <div class="nav-card" @click="$router.push('/crew')">舰员管理</div>
      <div class="nav-card" @click="$router.push('/explore')">星域探索</div>
      <div class="nav-card" @click="$router.push('/shop')">星际商店</div>
      <div class="nav-card" @click="$router.push('/inventory')">我的货舱</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const commanderName = ref('');

onMounted(() => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (user) {
    commanderName.value = user.name;
  }
});
</script>

<style scoped>
.home-container { padding: 40px; text-align: center; }
.hero { margin-bottom: 50px; }
.dashboard { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; max-width: 600px; margin: 0 auto; }
.nav-card { padding: 40px; background: #2a2a40; color: white; cursor: pointer; border-radius: 12px; transition: 0.3s; }
.nav-card:hover { background: #00d4ff; color: #000; }
</style>