import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // 自动引入 router/index.js

const app = createApp(App);

app.use(router); // 注册路由
app.mount('#app');