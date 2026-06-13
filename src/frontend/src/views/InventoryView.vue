<template>

  <div class="inventory-page">

    <div class="stars"></div>

    <div class="header">

      <div class="logo">
        📦
      </div>

      <h1>星舰货舱</h1>

      <p>
        当前舰队储备资源
      </p>

    </div>

    <div
        v-if="items.length > 0"
        class="inventory-grid"
    >

      <div
          v-for="item in items"
          :key="item.id"
          class="item-card"
      >

        <div class="item-icon">
          <img :src="item.icon" :alt="item.name" v-if="item.icon" />
          <span v-else>📦</span>
        </div>

        <h3>

          {{ item.name }}

        </h3>

        <p class="desc">

          {{ item.desc }}

        </p>

        <div class="amount">

          数量 × {{ item.amount }}

        </div>

      </div>

    </div>

    <div
        v-else
        class="empty-panel"
    >

      <div class="empty-icon">
        🛰
      </div>

      <h3>
        货舱为空
      </h3>

      <p>
        前往探索或补给舱获取资源
      </p>

    </div>

  </div>

</template>

<script setup>

import { ref,onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user } = useUser()

const items = ref([])

const fetchInventory = async()=>{

  if(!user.value){

    return

  }

  try{

    const res = await request.get(
        '/items',
        {
          params:{
            userId:user.value.id
          }
        }
    )

    items.value = res || []

  }catch(err){

    console.error(err)

    alert('货舱加载失败')

  }

}

onMounted(()=>{

  fetchInventory()

})

</script>

<style scoped>

.inventory-page{

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

/* 星空 */

.stars{

  position:absolute;

  inset:0;

  pointer-events:none;

  opacity:.45;

  background-image:
      radial-gradient(2px 2px at 50px 80px,#fff,transparent),
      radial-gradient(2px 2px at 180px 150px,#fff,transparent),
      radial-gradient(2px 2px at 320px 60px,#fff,transparent),
      radial-gradient(2px 2px at 520px 200px,#fff,transparent),
      radial-gradient(2px 2px at 760px 100px,#fff,transparent);

  background-size:900px 450px;

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

  margin-bottom:40px;
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
}

/* 物品列表 */

.inventory-grid {
  position: relative;
  z-index: 10;
  display: grid;
  /* 将基础宽度从 260px 缩小到 180px 或 200px，让一行能放下更多卡片 */
  grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
  gap: 20px; /* 稍微缩小间距 */
}

.item-card {
  padding: 20px 15px; /* 减小上下左右的内边距 */
  border-radius: 16px; /* 圆角稍微收敛一点 */
  text-align: center;
  background: rgba(10, 18, 35, 0.75);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(0, 212, 255, 0.15);
  transition: 0.35s;
}

.item-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 0 25px rgba(0, 212, 255, 0.25);
}

.item-icon {
  /* 【关键】给图标容器一个固定的宽高，防止图片把卡片撑爆 */
  width: 80px;
  height: 80px;
  margin: 0 auto 15px auto; /* 保证居中 */
  display: flex;
  justify-content: center;
  align-items: center;
  font-size: 42px; /* 缩小没有图片时的 emoji 大小 */
}

.item-icon img {
  width: 90%; /* 基于固定的 80px 容器进行缩放，留出一点呼吸感 */
  height: 90%;
  object-fit: contain;
  display: block;
}

.item-card h3 {
  color: white;
  margin-bottom: 8px;
  font-size: 16px; /* 稍微调小标题字号 */
}

.desc{

  color:#9db6d5;

  min-height:45px;
}

.amount{

  margin-top:18px;

  color:#ffd54f;

  font-size:22px;

  font-weight:bold;
}

/* 空货舱 */

.empty-panel{

  position:relative;

  z-index:10;

  max-width:500px;

  margin:80px auto;

  text-align:center;

  padding:40px;

  border-radius:24px;

  background:
      rgba(10,18,35,.75);

  backdrop-filter:blur(15px);

  border:
      1px solid rgba(0,212,255,.15);
}

.empty-icon{

  font-size:72px;

  margin-bottom:15px;
}

.empty-panel h3{

  color:white;

  margin-bottom:10px;
}

.empty-panel p{

  color:#9db6d5;
}

@media(max-width:768px){

  .inventory-page{

    padding:20px;
  }

  .header h1{

    font-size:28px;
  }

}

</style>