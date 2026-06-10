<template>

  <div class="explore-page">

    <div class="stars"></div>

    <div class="header">

      <div class="logo">
        🌌
      </div>

      <h1>星域探索中心</h1>

      <p>
        指派舰员执行深空任务
      </p>

    </div>

    <div class="explore-panel">

      <div class="section">

        <h3>
          选择目标星域
        </h3>

        <div class="location-grid">

          <div
              class="location-card"
              :class="{
                active:selectedLoc===1
              }"
              @click="selectedLoc=1"
          >
            <h4>☀️ 太阳系前哨站</h4>
            <p>探索消耗：10</p>
          </div>

          <div
              class="location-card"
              :class="{
                active:selectedLoc===2
              }"
              @click="selectedLoc=2"
          >
            <h4>⭐ 天狼星资源带</h4>
            <p>探索消耗：20</p>
          </div>

          <div
              class="location-card"
              :class="{
                active:selectedLoc===3
              }"
              @click="selectedLoc=3"
          >
            <h4>🛰 猎户座遗迹</h4>
            <p>探索消耗：35</p>
          </div>

        </div>

      </div>

      <div class="section">

        <h3>
          指派舰员
        </h3>

        <select
            v-model="selectedCrewId"
        >

          <option
              :value="null"
          >
            请选择舰员
          </option>

          <option
              v-for="crew in crewList"
              :key="crew.id"
              :value="crew.id"
          >

            {{ crew.nickname }}
            （疲劳:
            {{ crew.fatigue }}
            /
            {{ crew.fatigueMax }}
            ）

          </option>

        </select>

      </div>

      <button
          class="start-btn"
          @click="startExplore"
          :disabled="
            !selectedCrewId ||
            !selectedLoc
          "
      >
        🚀 开始执行任务
      </button>

    </div>

  </div>

</template>

<script setup>

import { ref,onMounted } from 'vue'
import request from '../api/request'
import { useUser } from '../status/useUser'

const { user,updateCoins } = useUser()

const crewList = ref([])

const selectedCrewId = ref(null)

const selectedLoc = ref(null)

/* 加载舰员 */

const fetchCrews = async()=>{

  if(!user.value){

    return

  }

  try{

    const res = await request.get(
        '/crew',
        {
          params:{
            userId:user.value.id
          }
        }
    )

    crewList.value = res || []

  }catch(err){

    console.error(err)

    alert('舰员加载失败')

  }

}

/* 开始探索 */

const startExplore = async()=>{

  if(!selectedCrewId.value){

    alert('请选择舰员')

    return

  }

  if(!selectedLoc.value){

    alert('请选择探索区域')

    return

  }

  try{

    const res = await request.post(
        '/explore',
        null,
        {
          params:{
            userId:user.value.id,
            crewId:selectedCrewId.value,
            locId:selectedLoc.value
          }
        }
    )

    if(res.code === 0){

      alert(
          '探索报告\n\n' +
          res.msg
      )

      if(
          res.data &&
          res.data.newCoins !== undefined
      ){

        updateCoins(
            res.data.newCoins
        )

      }

      await fetchCrews()

    }else{

      alert(
          '探索失败：' +
          res.msg
      )

    }

  }catch(err){

    console.error(err)

    alert('服务器连接失败')

  }

}

onMounted(()=>{

  fetchCrews()

})

</script>

<style scoped>

.explore-page{

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

/* 顶部标题 */

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

  letter-spacing:2px;
}

/* 主面板 */

.explore-panel{

  position:relative;

  z-index:10;

  max-width:1000px;

  margin:auto;

  padding:35px;

  border-radius:25px;

  background:
      rgba(10,18,35,.72);

  backdrop-filter:blur(15px);

  border:
      1px solid rgba(0,212,255,.15);

  box-shadow:
      0 0 25px rgba(0,212,255,.08);
}

.section{

  margin-bottom:35px;
}

.section h3{

  color:white;

  margin-bottom:18px;

  font-size:22px;
}

/* 星域选择 */

.location-grid{

  display:grid;

  grid-template-columns:
      repeat(auto-fit,minmax(250px,1fr));

  gap:20px;
}

.location-card{

  padding:22px;

  border-radius:18px;

  cursor:pointer;

  transition:.35s;

  background:
      rgba(255,255,255,.04);

  border:
      1px solid rgba(255,255,255,.08);
}

.location-card:hover{

  transform:
      translateY(-5px);

  box-shadow:
      0 0 25px rgba(0,212,255,.2);
}

.location-card.active{

  border:
      1px solid #00d4ff;

  background:
      rgba(0,212,255,.12);

  box-shadow:
      0 0 25px rgba(0,212,255,.4);
}

.location-card h4{

  color:white;

  margin-bottom:10px;
}

.location-card p{

  color:#9db6d5;
}

/* 下拉框 */

select{

  width:100%;

  padding:14px;

  border-radius:14px;

  border:
      1px solid rgba(0,212,255,.2);

  background:
      rgba(255,255,255,.06);

  color:white;

  font-size:15px;

  outline:none;
}

select option{

  background:#08111f;

  color:white;
}

/* 按钮 */

.start-btn{

  width:100%;

  padding:16px;

  border:none;

  border-radius:16px;

  cursor:pointer;

  font-size:17px;

  font-weight:bold;

  color:white;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  box-shadow:
      0 0 20px rgba(0,212,255,.3);

  transition:.3s;
}

.start-btn:hover:not(:disabled){

  transform:
      translateY(-2px)
      scale(1.02);

  box-shadow:
      0 0 30px rgba(0,212,255,.7);
}

.start-btn:disabled{

  cursor:not-allowed;

  opacity:.5;
}

/* 手机适配 */

@media(max-width:768px){

  .explore-page{

    padding:20px;
  }

  .explore-panel{

    padding:20px;
  }

  .header h1{

    font-size:28px;
  }

}

</style>