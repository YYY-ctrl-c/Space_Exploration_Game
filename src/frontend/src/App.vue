<template>
  <div id="app">
    <nav class="navbar">
      <div class="logo">🚀 太空探索指挥中心</div>

      <div v-if="user" class="user-info">
        指挥官：{{ user.name }} |
        <span class="gold">💰 金币: {{ user.coins || 0 }}</span>
      </div>

      <div v-if="user" class="nav-links">
        <router-link to="/home">指挥室</router-link>
        <router-link to="/crew">舰员管理</router-link>
        <router-link to="/explore">星域探索</router-link>
        <router-link to="/shop">星际商店</router-link>
        <router-link to="/inventory">我的货舱</router-link>
        <router-link to="/gacha">补给舱</router-link>
        <router-link to="/codex">招募图鉴</router-link>
      </div>

      <div class="auth-action">
        <router-link v-if="!user" to="/login">登录</router-link>
        <a v-else @click="handleLogout" class="logout-btn">退出登录</a>
      </div>
    </nav>

    <router-view />
  </div>
</template>

<script setup>
import { useUser } from './status/useUser'; // 确保路径正确
import { useRouter } from 'vue-router';

// 只需要获取 user 和 setUser
const { user, setUser } = useUser();
const router = useRouter();

const handleLogout = () => {
  setUser(null); // 清除全局状态
  router.push('/login');
};
</script>

<style>
/* 样式保持不变 */
.navbar { background: #1a1a2e; color: #fff; padding: 1rem; display: flex; justify-content: space-between; align-items: center; }
.user-info { color: #00d4ff; font-weight: bold; }
.gold { color: #ffd700; margin-left: 10px; }
.nav-links a { color: #a0a0c0; margin: 0 10px; text-decoration: none; }
.nav-links a.router-link-active { color: #00d4ff; font-weight: bold; }
.logout-btn { color: #ff4d4f; cursor: pointer; text-decoration: underline; }
.auth-action a { color: #00d4ff; text-decoration: none; }
</style>