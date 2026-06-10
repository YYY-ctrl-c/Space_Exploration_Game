<template>

  <div class="home-page">

    <div class="stars"></div>
    <div class="stars stars2"></div>

    <div class="radar"></div>

    <div class="hero">

      <div class="commander-logo">
        🚀
      </div>

      <h1>
        欢迎回来，指挥官
      </h1>

      <h2>
        {{ commanderName }}
      </h2>

      <p>
        星际舰队控制中心运行正常
      </p>

    </div>

    <div class="dashboard">

      <div
          class="nav-card"
          @click="$router.push('/crew')"
      >
        <div class="icon">👨‍🚀</div>
        <h3>舰员管理</h3>
        <p>查看与管理所有舰员</p>
      </div>

      <div
          class="nav-card"
          @click="$router.push('/explore')"
      >
        <div class="icon">🌌</div>
        <h3>星域探索</h3>
        <p>派遣舰员执行任务</p>
      </div>

      <div
          class="nav-card"
          @click="$router.push('/shop')"
      >
        <div class="icon">🛰️</div>
        <h3>星际商店</h3>
        <p>购买舰队补给物资</p>
      </div>

      <div
          class="nav-card"
          @click="$router.push('/inventory')"
      >
        <div class="icon">📦</div>
        <h3>我的货舱</h3>
        <p>查看已拥有的物品</p>
      </div>

      <div
          class="nav-card"
          @click="$router.push('/gacha')"
      >
        <div class="icon">🎁</div>
        <h3>补给舱</h3>
        <p>抽取新的舰员角色</p>
      </div>

      <div
          class="nav-card"
          @click="$router.push('/codex')"
      >
        <div class="icon">📖</div>
        <h3>招募图鉴</h3>
        <p>查看舰员收集进度</p>
      </div>

    </div>

  </div>

</template>

<script setup>

import { ref,onMounted } from 'vue'

const commanderName = ref('未知指挥官')

onMounted(()=>{

  try{

    const userStr =
        sessionStorage.getItem('user')

    console.log(
        '当前登录用户:',
        userStr
    )

    if(userStr){

      const user =
          JSON.parse(userStr)

      commanderName.value =
          user.name ||
          user.account ||
          user.username ||
          '未知指挥官'

    }

  }catch(err){

    console.error(err)

  }

})

</script>

<style scoped>

.home-page{
  min-height:100vh;
  padding:40px;
  position:relative;
  overflow:hidden;
  background:
      radial-gradient(
          circle at top,
          #163d73 0%,
          #08111f 45%,
          #02050b 100%
      );
}

.stars{
  position:absolute;
  inset:0;
  pointer-events:none;
  background-image:
      radial-gradient(2px 2px at 50px 80px,#fff,transparent),
      radial-gradient(2px 2px at 180px 150px,#fff,transparent),
      radial-gradient(2px 2px at 320px 60px,#fff,transparent),
      radial-gradient(2px 2px at 520px 200px,#fff,transparent);
  background-size:900px 450px;
  animation:starMove 60s linear infinite;
  opacity:.6;
}

.stars2{
  opacity:.3;
  transform:scale(1.5);
  animation-duration:100s;
}

@keyframes starMove{
  from{
    transform:translateY(0);
  }
  to{
    transform:translateY(-450px);
  }
}

.radar{
  position:absolute;
  top:50%;
  left:50%;
  width:900px;
  height:900px;
  transform:translate(-50%,-50%);
  border-radius:50%;
  border:1px solid rgba(0,212,255,.05);
  pointer-events:none;
  animation:rotateRadar 25s linear infinite;
}

.radar::before{
  content:'';
  position:absolute;
  inset:0;
  border-radius:50%;
  background:
      conic-gradient(
          transparent,
          rgba(0,212,255,.15),
          transparent 35deg
      );
}

@keyframes rotateRadar{
  from{
    transform:
        translate(-50%,-50%)
        rotate(0deg);
  }
  to{
    transform:
        translate(-50%,-50%)
        rotate(360deg);
  }
}

.hero{
  position:relative;
  z-index:10;
  text-align:center;
  margin-bottom:50px;
}

.commander-logo{
  width:100px;
  height:100px;
  margin:auto;
  border-radius:50%;
  display:flex;
  justify-content:center;
  align-items:center;
  font-size:50px;
  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );
  box-shadow:
      0 0 30px rgba(0,212,255,.6);
}

.hero h1{
  color:white;
  margin-top:20px;
  font-size:36px;
  letter-spacing:3px;
}

.hero h2{
  color:#00d4ff;
  font-size:30px;
  margin-top:10px;
  text-shadow:
      0 0 12px #00d4ff;
}

.hero p{
  color:#8ea9c7;
  margin-top:12px;
}

.dashboard{
  position:relative;
  z-index:10;
  max-width:1200px;
  margin:auto;
  display:grid;
  grid-template-columns:
      repeat(auto-fit,minmax(280px,1fr));
  gap:25px;
}

.nav-card{
  padding:30px;
  border-radius:22px;
  text-align:center;
  cursor:pointer;
  background:
      rgba(10,18,35,.75);
  backdrop-filter:blur(12px);
  border:1px solid rgba(0,212,255,.15);
  transition:.35s;
}

.nav-card:hover{
  transform:
      translateY(-8px)
      scale(1.03);
  box-shadow:
      0 0 30px rgba(0,212,255,.25);
}

.icon{
  font-size:50px;
  margin-bottom:15px;
}

.nav-card h3{
  color:white;
  margin-bottom:10px;
  font-size:22px;
}

.nav-card p{
  color:#91accb;
  line-height:1.6;
}

</style>