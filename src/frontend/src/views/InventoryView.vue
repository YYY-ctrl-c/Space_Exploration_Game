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

.inventory-grid{

  position:relative;

  z-index:10;

  display:grid;

  grid-template-columns:
      repeat(auto-fill,minmax(260px,1fr));

  gap:25px;
}

.item-card{

  padding:25px;

  border-radius:22px;

  text-align:center;

  background:
      rgba(10,18,35,.75);

  backdrop-filter:blur(15px);

  border:
      1px solid rgba(0,212,255,.15);

  transition:.35s;
}

.item-card:hover{

  transform:
      translateY(-8px);

  box-shadow:
      0 0 25px rgba(0,212,255,.25);
}

.item-icon{

  font-size:52px;

  margin-bottom:15px;
}

/* 控制里面真实图片的大小 */
.item-icon img {
  width: 75%; /* 不设为100%是为了让圆框留出一点发光的内边距，更有科技感 */
  height: 75%;
  object-fit: contain; /* 保证物资图片完整显示不被拉伸 */
  display: block;
}

.item-card h3{

  color:white;

  margin-bottom:12px;
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