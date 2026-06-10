<template>

  <div class="crew-page">

    <div class="stars"></div>

    <div class="header">

      <div class="logo">
        👨‍🚀
      </div>

      <h1>舰员指挥中心</h1>

      <p>
        管理舰队成员与恢复状态
      </p>

    </div>

    <div class="crew-grid">

      <div
          v-for="crew in crewList"
          :key="crew.id"
          class="crew-card"
      >

        <div class="crew-avatar">

          🚀

        </div>

        <h3>
          {{ crew.nickname }}
        </h3>

        <div class="fatigue-section">

          <div class="fatigue-label">
            疲劳度
          </div>

          <div class="fatigue-bar">

            <div
                class="fatigue-fill"
                :style="{
                  width:
                  (
                    crew.fatigue /
                    crew.fatigueMax
                  ) * 100 + '%'
                }"
            ></div>

          </div>

          <div class="fatigue-text">

            {{ crew.fatigue }}
            /
            {{ crew.fatigueMax }}

          </div>

        </div>

        <div class="recovery-section">

          <select
              v-model="selectedItem[crew.id]"
          >

            <option
                value=""
            >
              选择恢复物品
            </option>

            <option
                v-for="item in getAvailableItems(crew)"
                :key="item.id"
                :value="item.id"
            >

              {{ item.name }}
              ×{{ item.amount }}
              （恢复{{ item.supplyPower }}）

            </option>

          </select>

          <button
              @click="
                restCrew(
                  crew.id,
                  selectedItem[crew.id]
                )
              "
          >

            补充能量

          </button>

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

const items = ref([])

const selectedItem = ref({})

/* 加载舰员 */

const fetchCrews = async()=>{

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

/* 加载恢复道具 */

const fetchItems = async()=>{

  try{

    const itemsRes = await request.get(
        '/items',
        {
          params:{
            userId:user.value.id
          }
        }
    )

    const shopRes =
        await request.get('/shop')

    const powerMap =
        new Map()

    shopRes.forEach(s=>{

      if(s.supplyPower > 0){

        powerMap.set(
            s.id,
            s.supplyPower
        )

      }

    })

    items.value = itemsRes
        .filter(i =>
            powerMap.has(i.id)
        )
        .map(i=>({

          ...i,

          supplyPower:
              powerMap.get(i.id)

        }))

  }catch(err){

    console.error(err)

  }

}

/* 获取可用恢复物品 */

const getAvailableItems = (crew)=>{

  return items.value.filter(item=>{

    if(item.amount <= 0){

      return false

    }

    // 通用恢复包

    if(item.id === 16){

      return true

    }

    // 专属恢复道具

    if(
        item.id >= 1 &&
        item.id <= 15 &&
        item.id === crew.crewId
    ){

      return true

    }

    return false

  })

}

/* 恢复舰员 */

const restCrew = async(
    crewId,
    itemId
)=>{

  if(!itemId){

    alert('请选择恢复物品')

    return

  }

  try{

    const res =
        await request.post(
            '/crew',
            null,
            {
              params:{
                crewId,
                itemId
              }
            }
        )

    if(res.code === 0){

      alert('能量补充成功')

      selectedItem.value[
          crewId
          ] = null

      await fetchCrews()

      await fetchItems()

    }else{

      alert(
          '恢复失败：' +
          res.msg
      )

    }

  }catch(err){

    console.error(err)

    alert('服务器连接失败')

  }

}

/* 页面初始化 */

onMounted(async()=>{

  if(!user.value){

    return

  }

  await fetchCrews()

  await fetchItems()

})

</script>

<style scoped>

.crew-page{

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

/* 标题区域 */

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

  letter-spacing:2px;
}

/* 舰员列表 */

.crew-grid{

  position:relative;

  z-index:10;

  display:grid;

  grid-template-columns:
      repeat(auto-fill,minmax(320px,1fr));

  gap:25px;
}

/* 舰员卡片 */

.crew-card{

  padding:25px;

  border-radius:24px;

  background:
      rgba(10,18,35,.75);

  backdrop-filter:blur(14px);

  border:
      1px solid rgba(0,212,255,.15);

  text-align:center;

  transition:.35s;
}

.crew-card:hover{

  transform:
      translateY(-8px);

  box-shadow:
      0 0 30px rgba(0,212,255,.25);
}

/* 舰员头像 */

.crew-avatar{

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
      0 0 20px rgba(0,212,255,.4);

  margin-bottom:18px;
}

.crew-card h3{

  color:white;

  margin-bottom:20px;

  font-size:24px;
}

/* 疲劳度 */

.fatigue-section{

  margin-bottom:20px;
}

.fatigue-label{

  color:#9db6d5;

  margin-bottom:8px;
}

.fatigue-bar{

  width:100%;

  height:12px;

  border-radius:10px;

  overflow:hidden;

  background:
      rgba(255,255,255,.08);
}

.fatigue-fill{

  height:100%;

  border-radius:10px;

  background:
      linear-gradient(
          90deg,
          #00d4ff,
          #00ff95
      );

  transition:.5s;
}

.fatigue-text{

  margin-top:8px;

  color:#ffffff;

  font-weight:bold;
}

/* 恢复区域 */

.recovery-section{

  display:flex;

  flex-direction:column;

  gap:12px;
}

select{

  width:100%;

  padding:12px;

  border-radius:12px;

  border:
      1px solid rgba(0,212,255,.2);

  background:
      rgba(255,255,255,.06);

  color:white;

  outline:none;
}

select option{

  background:#08111f;

  color:white;
}

button{

  width:100%;

  padding:13px;

  border:none;

  border-radius:12px;

  cursor:pointer;

  font-weight:bold;

  color:white;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  transition:.3s;

  box-shadow:
      0 0 15px rgba(0,212,255,.25);
}

button:hover{

  transform:
      translateY(-2px)
      scale(1.02);

  box-shadow:
      0 0 25px rgba(0,212,255,.6);
}

button:active{

  transform:scale(.98);
}

/* 手机适配 */

@media(max-width:768px){

  .crew-page{

    padding:20px;
  }

  .header h1{

    font-size:28px;
  }

  .crew-grid{

    grid-template-columns:1fr;
  }

}

</style>