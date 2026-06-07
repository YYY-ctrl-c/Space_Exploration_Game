import { createRouter, createWebHistory } from 'vue-router';

// 导入所有页面
import LoginView from '../views/LoginView.vue';
import HomeView from '../views/HomeView.vue';
import CrewListView from '../views/CrewListView.vue';
import ExploreView from '../views/ExploreView.vue';
import GachaView from '../views/GachaView.vue';
import ShopView from '../views/ShopView.vue';
import InventoryView from '../views/InventoryView.vue';
import CrewCodexView from '../views/CrewCodexView.vue';

const routes = [
    { path: '/', redirect: '/login' },
    { path: '/login', component: LoginView },
    { path: '/home', component: HomeView },
    { path: '/crew', component: CrewListView },
    { path: '/explore', component: ExploreView },
    { path: '/gacha', component: GachaView },
    { path: '/shop', component: ShopView },
    { path: '/inventory', component: InventoryView },
    { path: '/codex', component: CrewCodexView}
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

// 添加路由守卫
router.beforeEach((to, from, next) => {
    // 检查是否存在 user
    const user = sessionStorage.getItem('user');

    // 加个打印，看看是否触发
    console.log('当前访问路径:', to.path);
    console.log('当前登录用户:', user);

    // 如果前往的不是登录页，且没有登录状态
    if (to.path !== '/login' && !user) {
        alert('您尚未登录，请先登录！');
        next('/login');
    } else {
        next();
    }
});

export default router;