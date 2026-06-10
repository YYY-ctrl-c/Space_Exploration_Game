<template>

  <div class="codex-page">

    <!-- 星空背景 -->
    <div class="stars"></div>

    <!-- 页面标题 -->

    <div class="header">

      <div class="logo">
        📖
      </div>

      <h1>舰员图鉴</h1>

      <p>
        银河舰队档案数据库
      </p>

    </div>

    <!-- 图鉴列表 -->

    <div class="crew-grid">

      <div
          v-for="item in crewList"
          :key="item.id"
          :class="[
            'crew-card',
            { locked: !item.isOwned }
          ]"
      >

        <!-- 稀有度顶部发光条 -->

        <div
            class="rarity-bar"
            :class="item.rarity?.toLowerCase()"
        ></div>

        <!-- 头像 -->

        <div class="avatar-box">

          <img
              :src="item.icon"
              :alt="item.name"
          >

        </div>

        <!-- 名称 -->

        <h3>

          {{
            item.isOwned
                ? item.name
                : '？？？'
          }}

        </h3>

        <!-- 描述 -->

        <p class="desc">

          {{
            item.isOwned
                ? item.description
                : '该舰员尚未招募'
          }}

        </p>

        <!-- 稀有度 -->

        <div
            class="rarity"
            :class="item.rarity?.toLowerCase()"
        >

          {{ item.rarity }}

        </div>

      </div>

    </div>

  </div>

</template>

<script setup>

import { ref,onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user } = useUser()

const crewList = ref([])

/**
 * 加载图鉴
 */
const fetchCrewList = async()=>{

  if(!user.value){

    alert('请先登录')

    return

  }

  try{

    const res = await request.get(
        '/crew-codex',
        {
          params:{
            userId:user.value.id
          }
        }
    )

    crewList.value = res || []

  }catch(err){

    console.error(err)

    alert('图鉴加载失败')

  }

}

onMounted(()=>{

  fetchCrewList()

})

</script>

<style scoped>

.codex-page{

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

/* 星空背景 */

.stars{

  position:absolute;

  inset:0;

  pointer-events:none;

  background-image:
      radial-gradient(2px 2px at 50px 80px,#fff,transparent),
      radial-gradient(2px 2px at 180px 150px,#fff,transparent),
      radial-gradient(2px 2px at 320px 60px,#fff,transparent),
      radial-gradient(2px 2px at 520px 200px,#fff,transparent),
      radial-gradient(2px 2px at 700px 120px,#fff,transparent);

  background-size:900px 450px;

  opacity:.5;

  animation:starMove 60s linear infinite;
}

@keyframes starMove{

  from{
    transform:translateY(0);
  }

  to{
    transform:translateY(-450px);
  }
}

/* 标题 */

.header{

  position:relative;

  z-index:10;

  text-align:center;

  margin-bottom:45px;
}

.logo{

  width:90px;
  height:90px;

  margin:auto;

  border-radius:50%;

  display:flex;
  justify-content:center;
  align-items:center;

  font-size:42px;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  box-shadow:
      0 0 25px rgba(0,212,255,.6);
}

.header h1{

  margin-top:18px;

  color:white;

  font-size:38px;

  letter-spacing:3px;

  text-shadow:
      0 0 10px #00d4ff,
      0 0 20px #00d4ff;
}

.header p{

  margin-top:10px;

  color:#8ea9c7;

  font-size:14px;

  letter-spacing:2px;
}

/* 网格 */

.crew-grid{

  position:relative;

  z-index:10;

  display:grid;

  grid-template-columns:
      repeat(auto-fill,minmax(260px,1fr));

  gap:24px;
}

/* 卡片 */

.crew-card{

  position:relative;

  overflow:hidden;

  padding:24px;

  border-radius:22px;

  text-align:center;

  background:
      rgba(10,18,35,.75);

  backdrop-filter:blur(12px);

  border:
      1px solid rgba(0,212,255,.15);

  transition:.35s;
}

.crew-card:hover{

  transform:
      translateY(-8px);

  box-shadow:
      0 0 30px rgba(0,212,255,.25);
}

/* 稀有度发光条 */

.rarity-bar{

  position:absolute;

  top:0;
  left:0;

  width:100%;
  height:5px;
}

.rarity-bar.common{
  background:#bdbdbd;
}

.rarity-bar.rare{
  background:#42a5f5;
}

.rarity-bar.epic{
  background:#ab47bc;
}

.rarity-bar.legendary{
  background:#ffb300;
}

/* 头像 */

.avatar-box{

  width:110px;
  height:110px;

  margin:auto;

  border-radius:50%;

  overflow:hidden;

  border:
      2px solid rgba(0,212,255,.3);

  box-shadow:
      0 0 15px rgba(0,212,255,.2);

  margin-bottom:18px;
}

.avatar-box img{

  width:100%;
  height:100%;

  object-fit:cover;
}

/* 未拥有 */

.locked{

  opacity:.7;
}

.locked img{

  filter:
      grayscale(100%)
      brightness(.4);
}

/* 名称 */

h3{

  color:white;

  margin-bottom:12px;

  font-size:22px;
}

/* 描述 */

.desc{

  color:#9bb8d6;

  line-height:1.6;

  min-height:55px;
}

/* 稀有度 */

.rarity{

  margin-top:16px;

  font-size:15px;

  font-weight:bold;
}

.rarity.common{
  color:#bdbdbd;
}

.rarity.rare{
  color:#42a5f5;
}

.rarity.epic{
  color:#ab47bc;
}

.rarity.legendary{
  color:#ffb300;
}

/* 响应式 */

@media(max-width:768px){

  .codex-page{
    padding:20px;
  }

  .header h1{
    font-size:28px;
  }

  .crew-grid{

    grid-template-columns:
        repeat(auto-fill,minmax(180px,1fr));
  }

}

</style>