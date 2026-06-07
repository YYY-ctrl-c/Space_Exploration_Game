<template>
  <div class="login-container">
    <h2>星际指挥官认证</h2>
    <input v-model="form.account" placeholder="输入账号" />
    <input v-model="form.pass" type="password" placeholder="输入密钥" />
    <button @click="handleLogin">登录</button>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import request from '../api/request';
import { useUser } from '../status/useUser'; // 1. 引入你的状态管理

const router = useRouter();
const { setUser } = useUser(); // 2. 获取 setUser 方法
const form = ref({ account: '', pass: '' });

const handleLogin = async () => {
  const res = await request.post('/auth/login', null, {
    params: { account: form.value.account, pass: form.value.pass }
  });

  if (res.code === 0) {
    // 【关键修改】不要只写 sessionStorage，要调用 setUser
    // setUser 会自动帮你存 sessionStorage 并更新全局的 user 变量
    setUser(res.data);

    router.push('/home'); // 登录成功后跳转
  } else {
    alert(res.msg);
  }
};
</script>

<style scoped>
.login-container { max-width: 300px; margin: 100px auto; text-align: center; }
input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
button { width: 100%; padding: 10px; background: #00d4ff; border: none; cursor: pointer; }
</style>