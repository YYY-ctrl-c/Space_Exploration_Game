import { createRouter, createWebHistory } from 'vue-router';

// 导入所有页面
import LoginView from '../views/LoginView.vue';
import HomeView from '../views/HomeView.vue';
import CrewListView from '../views/CrewListView.vue';
import ExploreView from '../views/ExploreView.vue';
import GachaView from '../views/GachaView.vue';
import ShopView from '../views/ShopView.vue';
import InventoryView from '../views/InventoryView.vue';

const routes = [
    { path: '/', redirect: '/login' },
    { path: '/login', component: LoginView },
    { path: '/home', component: HomeView },
    { path: '/crew', component: CrewListView },
    { path: '/explore', component: ExploreView },
    { path: '/gacha', component: GachaView },
    { path: '/shop', component: ShopView },
    { path: '/inventory', component: InventoryView }
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;