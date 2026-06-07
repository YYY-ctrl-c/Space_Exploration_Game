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

const router = useRouter();
const form = ref({ account: '', pass: '' });

const handleLogin = async () => {
  // 注意：这里调用后端 /auth/login
  const res = await request.post('/auth/login', null, {
    params: { account: form.value.account, pass: form.value.pass }
  });

  if (res.code === 0) {
    localStorage.setItem('user', JSON.stringify(res.data));
    router.push('/home');
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