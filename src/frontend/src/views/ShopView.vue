<template>

  <div class="shop-page">

    <!-- 星空背景 -->
    <div class="stars"></div>
    <div class="stars stars2"></div>

    <!-- 雷达扫描 -->
    <div class="radar"></div>

    <!-- 顶部区域 -->
    <div class="shop-header">

      <div class="station-logo">
        🛰
      </div>

      <h1>星际补给站</h1>

      <p class="subtitle">
        INTERSTELLAR SUPPLY CENTER
      </p>

      <div class="coin-panel">

        <span class="coin-label">
          当前星币
        </span>

        <span class="coin-value">
          💰 {{ user?.coins || 0 }}
        </span>

      </div>

    </div>

    <!-- 商品区域 -->
    <div class="item-grid">

      <div
          v-for="item in items"
          :key="item.id"
          class="item-card"
      >

        <!-- 稀有度边框 -->
        <div
            class="rarity-bar"
            :class="{
              common:item.price < 500,
              rare:item.price >= 500 && item.price < 2000,
              epic:item.price >= 2000 && item.price < 5000,
              legendary:item.price >= 5000
            }"
        ></div>

        <!-- 图标 -->

        <div class="item-icon">

          <span v-if="item.price < 500">
            🔋
          </span>

          <span v-else-if="item.price < 2000">
            ⚙️
          </span>

          <span v-else-if="item.price < 5000">
            🚀
          </span>

          <span v-else>
            🛸
          </span>

        </div>

        <!-- 名称 -->

        <h3>
          {{ item.name }}
        </h3>

        <!-- 描述 -->

        <p class="desc">
          {{ item.description }}
        </p>

        <!-- 稀有度 -->

        <div class="rarity-text">

          <span v-if="item.price < 500">
            普通补给
          </span>

          <span v-else-if="item.price < 2000">
            稀有补给
          </span>

          <span v-else-if="item.price < 5000">
            史诗补给
          </span>

          <span v-else>
            传说补给
          </span>

        </div>

        <!-- 价格 -->

        <div class="price">
          💰 {{ item.price }}
        </div>

        <!-- 购买 -->

        <button
            class="buy-btn"
            @click="buyItem(item.id)"
        >
          购买补给
        </button>

      </div>

    </div>

  </div>

</template>

<script setup>

import { ref,onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user, updateCoins } = useUser()

const items = ref([])

/**
 * 加载商品
 */
const fetchItems = async ()=>{

  try{

    const res = await request.get('/shop')

    items.value = res.filter(item => {

      return item &&
          item.id &&
          item.name &&
          item.description &&
          item.price &&
          item.price > 0

    })

  }catch(err){

    console.error(err)

    alert('商品加载失败')

  }

}

/**
 * 购买商品
 */
const buyItem = async(itemId)=>{

  if(!user.value){

    alert('请先登录')

    return
  }

  try{

    const res = await request.post(
        '/shop',
        null,
        {
          params:{
            userId:user.value.id,
            itemId:itemId
          }
        }
    )

    if(res.code === 0){

      alert('补给购买成功')

      if(res.data){

        updateCoins(
            res.data.newCoins
        )

      }

      await fetchItems()

    }else{

      alert(res.msg)

    }

  }catch(err){

    console.error(err)

    alert('服务器连接失败')

  }

}

onMounted(()=>{

  fetchItems()

})

</script>

<style scoped>

/* 页面 */

.shop-page{

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

  background-image:
      radial-gradient(2px 2px at 50px 80px,#fff,transparent),
      radial-gradient(2px 2px at 180px 150px,#fff,transparent),
      radial-gradient(2px 2px at 320px 60px,#fff,transparent),
      radial-gradient(2px 2px at 520px 200px,#fff,transparent),
      radial-gradient(2px 2px at 750px 100px,#fff,transparent);

  background-size:900px 450px;

  animation:starMove 60s linear infinite;

  opacity:.6;
}

.stars2{

  opacity:.3;

  transform:scale(1.5);

  animation-duration:100s;

  pointer-events:none;
}

@keyframes starMove{

  from{
    transform:translateY(0);
  }

  to{
    transform:translateY(-450px);
  }
}

/* 雷达 */

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
          transparent 30deg
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

/* 顶部 */

.shop-header{

  position:relative;

  z-index:20;

  text-align:center;

  margin-bottom:50px;
}

/* Logo */

.station-logo{

  width:100px;
  height:100px;

  margin:auto;

  border-radius:50%;

  display:flex;
  align-items:center;
  justify-content:center;

  font-size:48px;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  box-shadow:
      0 0 30px rgba(0,212,255,.5);
}

.shop-header h1{

  color:white;

  font-size:42px;

  margin-top:20px;

  letter-spacing:4px;

  text-shadow:
      0 0 10px #00d4ff,
      0 0 25px #00d4ff;
}

.subtitle{

  color:#89a8cc;

  letter-spacing:4px;

  margin-top:8px;
}

/* 星币 */

.coin-panel{

  width:320px;

  margin:25px auto;

  padding:18px;

  border-radius:20px;

  background:
      rgba(10,18,35,.8);

  border:1px solid rgba(0,212,255,.2);

  backdrop-filter:blur(15px);

  display:flex;

  justify-content:space-between;

  align-items:center;

  box-shadow:
      0 0 20px rgba(0,212,255,.15);
}

.coin-label{

  color:#9bb6d6;
}

.coin-value{

  color:#00d4ff;

  font-size:24px;

  font-weight:bold;

  text-shadow:
      0 0 10px #00d4ff;
}

/* 商品区 */

.item-grid{

  position:relative;

  z-index:20;

  display:grid;

  grid-template-columns:
      repeat(auto-fill,minmax(280px,1fr));

  gap:28px;
}

/* 商品卡 */

.item-card{

  position:relative;

  overflow:hidden;

  padding:25px;

  border-radius:22px;

  background:
      rgba(10,18,35,.75);

  border:1px solid rgba(0,212,255,.12);

  backdrop-filter:blur(12px);

  text-align:center;

  transition:.35s;
}

.item-card:hover{

  transform:
      translateY(-8px)
      scale(1.02);

  box-shadow:
      0 0 30px rgba(0,212,255,.25);
}

/* 流光 */

.item-card::before{

  content:'';

  position:absolute;

  top:0;

  left:-150%;

  width:80%;

  height:100%;

  background:
      linear-gradient(
          90deg,
          transparent,
          rgba(255,255,255,.12),
          transparent
      );

  transition:.8s;
}

.item-card:hover::before{

  left:150%;
}

/* 稀有度条 */

.rarity-bar{

  position:absolute;

  top:0;
  left:0;

  width:100%;
  height:5px;
}

.common{
  background:#9e9e9e;
}

.rare{
  background:#2196f3;
}

.epic{
  background:#9c27b0;
}

.legendary{
  background:#ff9800;
}

/* 图标 */

.item-icon{

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
          rgba(0,212,255,.25),
          rgba(0,102,255,.25)
      );

  box-shadow:
      0 0 20px rgba(0,212,255,.2);

  margin-bottom:18px;
}

.item-card h3{

  color:white;

  font-size:22px;

  margin-bottom:10px;
}

.desc{

  color:#91accb;

  min-height:55px;

  line-height:1.7;
}

.rarity-text{

  margin-top:12px;

  color:#7bbcff;

  font-size:13px;
}

/* 价格 */

.price{

  margin:20px 0;

  color:#ffd54f;

  font-size:24px;

  font-weight:bold;

  text-shadow:
      0 0 10px rgba(255,213,79,.6);
}

/* 购买按钮 */

.buy-btn{

  width:100%;

  border:none;

  border-radius:14px;

  padding:14px;

  cursor:pointer;

  color:white;

  font-size:15px;

  font-weight:bold;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  transition:.3s;

  box-shadow:
      0 0 18px rgba(0,212,255,.3);
}

.buy-btn:hover{

  transform:translateY(-2px);

  box-shadow:
      0 0 28px rgba(0,212,255,.7);
}

.buy-btn:active{

  transform:scale(.98);
}

</style>