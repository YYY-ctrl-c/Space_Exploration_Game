<template>

  <div id="app">

    <nav
        class="navbar"
        v-if="user"
    >

      <div class="logo">
        🚀 星际舰队控制中心
      </div>

      <div class="user-info">

        <span class="commander">
          👩‍✈️️ 指挥官：{{ user.name }}
        </span>

        <span class="coins">
          💰 星币：{{ user.coins || 0 }}
        </span>

      </div>

      <div class="nav-links">

        <router-link to="/home">
          指挥室
        </router-link>

        <router-link to="/crew">
          舰员管理
        </router-link>

        <router-link to="/explore">
          星域探索
        </router-link>

        <router-link to="/shop">
          星际商店
        </router-link>

        <router-link to="/inventory">
          我的货舱
        </router-link>

        <router-link to="/gacha">
          补给舱
        </router-link>

        <router-link to="/codex">
          招募图鉴
        </router-link>

      </div>

      <div class="auth-action">

        <a
            @click="handleLogout"
            class="logout-btn"
        >
          退出登录
        </a>

      </div>

    </nav>

    <router-view/>

  </div>

</template>

<script setup>

import { useUser } from './status/useUser'
import { useRouter } from 'vue-router'

const { user,setUser } = useUser()

const router = useRouter()

const handleLogout = ()=>{

  sessionStorage.removeItem('user')

  setUser(null)

  router.push('/login')

}

</script>

<style>

/* 全局 */

*{
  margin:0;
  padding:0;
  box-sizing:border-box;
}

body{

  background:#02050b;

  font-family:
      "Microsoft YaHei",
      sans-serif;
}

/* 导航栏 */

.navbar{

  position:sticky;

  top:0;

  z-index:999;

  height:72px;

  display:flex;

  align-items:center;

  justify-content:space-between;

  padding:0 30px;

  background:
      rgba(7,15,30,.92);

  backdrop-filter:blur(15px);

  border-bottom:
      1px solid rgba(0,212,255,.15);

  box-shadow:
      0 0 20px rgba(0,212,255,.08);
}

/* Logo */

.logo{

  color:#00d4ff;

  font-size:24px;

  font-weight:700;

  letter-spacing:2px;

  text-shadow:
      0 0 10px rgba(0,212,255,.6);
}

/* 用户信息 */

.user-info{

  display:flex;

  gap:25px;

  font-size:18px;

  font-weight:bold;
}

.commander{

  color:#67d7ff;
}

.coins{

  color:#ffd54f;
}

/* 菜单 */

.nav-links{

  display:flex;

  gap:25px;
}

.nav-links a{

  color:#9bb6d6;

  text-decoration:none;

  transition:.3s;

  position:relative;
}

.nav-links a:hover{

  color:#00d4ff;
}

.nav-links a.router-link-active{

  color:#00d4ff;

  font-weight:bold;
}

.nav-links a.router-link-active::after{

  content:'';

  position:absolute;

  left:0;
  bottom:-8px;

  width:100%;
  height:2px;

  background:#00d4ff;

  box-shadow:
      0 0 10px #00d4ff;
}

/* 退出按钮 */

.logout-btn{

  color:#ff6b6b;

  cursor:pointer;

  transition:.3s;
}

.logout-btn:hover{

  color:#ff9090;

  text-shadow:
      0 0 10px rgba(255,107,107,.8);
}

/* 登录页隐藏导航 */

.auth-action a{

  text-decoration:none;
}

</style>