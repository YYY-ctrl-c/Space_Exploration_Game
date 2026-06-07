<template>
  <div id="app">
    <nav class="navbar">
      <div class="logo">🚀 太空探索指挥中心</div>
      <div class="nav-links">
        <router-link to="/home">指挥室</router-link>
        <router-link to="/crew">舰员管理</router-link>
        <router-link to="/explore">星域探索</router-link>
        <router-link to="/shop">星际商店</router-link>
        <router-link to="/inventory">我的货舱</router-link>
        <router-link to="/gacha">补给舱</router-link>
      </div>
    </nav>

    <router-view />
  </div>
</template>

<style>
.navbar {
  background: #1a1a2e;
  color: #fff;
  padding: 1rem;
  display: flex;
  justify-content: space-between;
  align-items: center;
}
.nav-links a {
  color: #a0a0c0;
  margin: 0 15px;
  text-decoration: none;
}
.nav-links a.router-link-active {
  color: #00d4ff;
  font-weight: bold;
}
</style>