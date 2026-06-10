<template>
  <div class="login-page">

    <div class="stars"></div>
    <div class="stars stars2"></div>

    <div class="radar"></div>

    <div class="login-card">

      <div class="logo-box">

        <div class="logo-circle">
          🚀
        </div>

        <h1>星际舰队控制中心</h1>

        <p class="subtitle">
          INTERSTELLAR COMMAND SYSTEM
        </p>

      </div>

      <div class="tabs">

        <button
            :class="{ active: mode==='login' }"
            @click="mode='login'"
        >
          登录
        </button>

        <button
            :class="{ active: mode==='register' }"
            @click="mode='register'"
        >
          注册
        </button>

      </div>

      <div class="input-group">

        <input
            v-model="form.account"
            placeholder="请输入账号"
        >

      </div>

      <div
          class="input-group"
          v-if="mode==='register'"
      >

        <input
            v-model="form.name"
            placeholder="舰长昵称"
        >

      </div>

      <div class="input-group">

        <input
            type="password"
            v-model="form.pass"
            placeholder="请输入密码"
        >

      </div>

      <button
          class="main-btn"
          @click="submit"
      >
        {{ mode==='login'
          ? '进入舰桥'
          : '创建舰长账号'
        }}
      </button>

    </div>

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import request from '../api/request'
import { useUser } from '../status/useUser'

const router = useRouter()
const { setUser } = useUser()

const mode = ref('login')

const form = ref({
  account:'',
  name:'',
  pass:''
})

const submit = async ()=>{

  if(!form.value.account || !form.value.pass){
    alert('请输入账号密码')
    return
  }

  try{

    if(mode.value === 'login'){

      const res = await request.post('/auth/login',null,{
        params:{
          account:form.value.account,
          pass:form.value.pass
        }
      })

      if(res.code===0){

        setUser(res.data)

        router.push('/home')

      }else{
        alert(res.msg)
      }

    }else{

      if(!form.value.name){
        alert('请输入舰长昵称')
        return
      }

      const res = await request.post('/auth/register',null,{
        params:{
          account:form.value.account,
          name:form.value.name,
          pass:form.value.pass
        }
      })

      alert(res.msg)

      if(res.code===0){
        mode.value='login'
      }

    }

  }catch(e){

    alert('服务器连接失败')

  }
}
</script>

<style scoped>

.login-page{
  position:relative;
  width:100%;
  height:100vh;
  overflow:hidden;

  display:flex;
  justify-content:center;
  align-items:center;

  background:
      radial-gradient(circle at top,#12386d 0%,#07111f 45%,#02050b 100%);
}

/* 星空背景 */

.stars{
  position:absolute;
  inset:0;
  pointer-events:none;
  z-index:1;

  background-image:
      radial-gradient(2px 2px at 20px 30px,#fff,transparent),
      radial-gradient(2px 2px at 120px 90px,#fff,transparent),
      radial-gradient(2px 2px at 250px 150px,#fff,transparent),
      radial-gradient(2px 2px at 400px 80px,#fff,transparent),
      radial-gradient(2px 2px at 600px 200px,#fff,transparent);

  background-size:800px 400px;

  animation:starMove 60s linear infinite;
}

.stars2{
  opacity:.4;
  transform:scale(1.5);
  animation-duration:100s;
}

@keyframes starMove{

  from{
    transform:translateY(0);
  }

  to{
    transform:translateY(-400px);
  }
}

/* 雷达 */

.radar{

  position:absolute;

  width:700px;
  height:700px;

  pointer-events:none;
  z-index:1;

  border-radius:50%;

  border:1px solid rgba(0,212,255,.08);

  background:
      repeating-radial-gradient(
          circle,
          rgba(0,212,255,.05),
          rgba(0,212,255,.05) 2px,
          transparent 2px,
          transparent 80px
      );

  animation:rotateRadar 20s linear infinite;
}

.radar::before{

  content:'';

  position:absolute;

  inset:0;

  border-radius:50%;

  background:
      conic-gradient(
          transparent,
          rgba(0,212,255,.35),
          transparent 35deg
      );
}

@keyframes rotateRadar{

  from{
    transform:rotate(0deg);
  }

  to{
    transform:rotate(360deg);
  }
}

/* 登录框 */

.login-card{

  position:relative;
  z-index:100;

  width:460px;

  padding:40px;

  border-radius:24px;

  background:
      rgba(7,15,30,.75);

  backdrop-filter:blur(18px);

  border:1px solid rgba(0,212,255,.25);

  box-shadow:
      0 0 25px rgba(0,212,255,.2),
      inset 0 0 30px rgba(0,212,255,.05);
}

/* 简化边框效果 */

.login-card::before{

  content:'';

  position:absolute;

  inset:0;

  border-radius:24px;

  border:1px solid rgba(0,212,255,.25);

  pointer-events:none;
}

.logo-box{
  text-align:center;
}

.logo-circle{

  width:80px;
  height:80px;

  margin:auto;

  display:flex;
  align-items:center;
  justify-content:center;

  border-radius:50%;

  font-size:38px;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  box-shadow:
      0 0 25px rgba(0,212,255,.6);
}

h1{

  margin-top:15px;

  color:white;

  font-size:30px;

  letter-spacing:3px;

  text-shadow:
      0 0 10px #00d4ff,
      0 0 20px #00d4ff;
}

.subtitle{

  color:#7ca0c9;

  font-size:12px;

  letter-spacing:4px;

  margin-bottom:30px;
}

/* tabs */

.tabs{

  display:flex;

  gap:10px;

  margin-bottom:20px;
}

.tabs button{

  flex:1;

  border:none;

  padding:12px;

  border-radius:12px;

  background:#12223d;

  color:#9bb8dc;

  transition:.3s;
}

.tabs button:hover{

  background:#1b3358;
}

.active{

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      ) !important;

  color:white !important;

  box-shadow:
      0 0 20px rgba(0,212,255,.5);
}

/* 输入框 */

.input-group{
  margin-bottom:14px;
}

input{

  width:100%;

  padding:14px 18px;

  border-radius:14px;

  border:1px solid rgba(0,212,255,.2);

  background:
      rgba(255,255,255,.05);

  color:white;

  font-size:15px;

  box-sizing:border-box;

  transition:.3s;
}

input::placeholder{
  color:#7c98bc;
}

input:focus{

  outline:none;

  border-color:#00d4ff;

  box-shadow:
      0 0 15px rgba(0,212,255,.45);
}

/* 主按钮 */

.main-btn{

  width:100%;

  margin-top:12px;

  padding:15px;

  border:none;

  border-radius:14px;

  color:white;

  font-size:16px;

  font-weight:700;

  cursor:pointer;

  background:
      linear-gradient(
          135deg,
          #00d4ff,
          #0066ff
      );

  box-shadow:
      0 0 20px rgba(0,212,255,.45);

  transition:.3s;
}

.main-btn:hover{

  transform:
      translateY(-2px)
      scale(1.02);

  box-shadow:
      0 0 35px rgba(0,212,255,.85);
}

.main-btn:active{

  transform:scale(.98);
}

button{
  cursor:pointer;
}

</style>