<template>

  <div class="gacha-page">

    <div class="stars"></div>

    <div class="header">

      <div class="logo">
        🎁
      </div>

      <h1>空间补给舱</h1>

      <p>
        开启补给获取舰员与珍稀资源
      </p>

      <div class="coin-panel">

        当前星币：

        <span>
          {{ user?.coins || 0 }}
        </span>

      </div>

    </div>

    <div class="gacha-grid">

      <!-- 普通补给 -->

      <div class="gacha-card normal">

        <div class="icon">
          📦
        </div>

        <h3>普通补给舱</h3>

        <p>
          获取基础资源与舰员
        </p>

        <div class="price">

          💰100

        </div>

        <button
            @click="handleGacha('normal')"
        >
          开启补给
        </button>

      </div>

      <!-- 高级补给 -->

      <div class="gacha-card advanced">

        <div class="icon">
          ✨
        </div>

        <h3>高级补给舱</h3>

        <p>
          更高概率获得稀有奖励
        </p>

        <div class="price">

          💰500

        </div>

        <button
            class="gold-btn"
            @click="handleGacha('advanced')"
        >
          开启高级补给
        </button>

      </div>

    </div>

    <!-- 抽奖结果 -->

    <div
        v-if="resultMsg"
        class="result-panel"
    >

      <h3>
        🎉 获得奖励
      </h3>

      <p>

        {{ resultMsg }}

      </p>

    </div>

  </div>

</template>

<script setup>

import { ref } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user, updateCoins } = useUser()

const resultMsg = ref('')

const handleGacha = async(type)=>{

  if(!user.value){

    alert('请先登录')

    return

  }

  try{

    const res = await request.post(
        '/gacha',
        null,
        {
          params:{
            userId:user.value.id,
            type:type
          }
        }
    )

    if(res.code === 0){

      resultMsg.value = res.msg

      if(
          res.data &&
          res.data.newCoins !== undefined
      ){

        updateCoins(
            res.data.newCoins
        )

      }

    }else{

      alert(res.msg)

    }

  }catch(err){

    console.error(err)

    alert('服务器连接失败')

  }

}

</script>

<style scoped>

.gacha-page{

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
      radial-gradient(2px 2px at 760px 100px,#fff,transparent);

  background-size:900px 450px;

  opacity:.45;

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
  align-items:center;
  justify-content:center;

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

  letter-spacing:2px;
}

/* 星币面板 */

.coin-panel{

  width:260px;

  margin:20px auto 0;

  padding:14px 20px;

  border-radius:16px;

  background:
      rgba(10,18,35,.72);

  backdrop-filter:blur(12px);

  border:
      1px solid rgba(0,212,255,.2);

  color:white;

  font-size:18px;
}

.coin-panel span{

  color:#00d4ff;

  font-size:22px;

  font-weight:bold;
}

/* 补给舱区域 */

.gacha-grid{

  position:relative;

  z-index:10;

  display:grid;

  grid-template-columns:
      repeat(auto-fit,minmax(320px,1fr));

  gap:30px;

  max-width:900px;

  margin:auto;
}

.gacha-card{

  padding:30px;

  border-radius:24px;

  text-align:center;

  background:
      rgba(10,18,35,.75);

  backdrop-filter:blur(15px);

  transition:.35s;
}

.gacha-card:hover{

  transform:
      translateY(-8px);

}

.gacha-card .icon{

  font-size:60px;

  margin-bottom:15px;
}

.gacha-card h3{

  color:white;

  font-size:26px;

  margin-bottom:10px;
}

.gacha-card p{

  color:#9db6d5;

  margin-bottom:20px;
}

/* 普通补给 */

.normal{

  border:
      1px solid rgba(0,212,255,.25);

  box-shadow:
      0 0 20px rgba(0,212,255,.15);
}

/* 高级补给 */

.advanced{

  border:
      1px solid rgba(255,193,7,.35);

  box-shadow:
      0 0 30px rgba(255,193,7,.25);
}

/* 价格 */

.price{

  font-size:30px;

  font-weight:bold;

  margin-bottom:20px;

  color:#ffd54f;
}

/* 按钮 */

button{

  width:100%;

  padding:15px;

  border:none;

  border-radius:14px;

  cursor:pointer;

  color:white;

  font-size:16px;

  font-weight:bold;

  transition:.3s;
}

button:hover{

  transform:
      scale(1.03);
}

.normal button{

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );
}

.gold-btn{

  background:
      linear-gradient(
          135deg,
          #ffeb3b,
          #ff9800
      );

  color:#111;
}

/* 结果面板 */

.result-panel{

  position:relative;

  z-index:10;

  max-width:600px;

  margin:40px auto 0;

  padding:25px;

  text-align:center;

  border-radius:20px;

  background:
      rgba(10,18,35,.78);

  backdrop-filter:blur(12px);

  border:
      1px solid rgba(0,212,255,.25);

  box-shadow:
      0 0 25px rgba(0,212,255,.25);
}

.result-panel h3{

  color:#ffd54f;

  margin-bottom:12px;

  font-size:28px;
}

.result-panel p{

  color:white;

  font-size:18px;

  line-height:1.8;
}

/* 手机适配 */

@media(max-width:768px){

  .gacha-page{

    padding:20px;
  }

  .header h1{

    font-size:28px;
  }

  .gacha-grid{

    grid-template-columns:1fr;
  }

}

</style>