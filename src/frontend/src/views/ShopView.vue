<template>
  <div class="shop-container">
    <h2>星际物资商店</h2>
    <p>使用星币购买能量补给，维持舰员状态</p>

    <div class="item-grid">
      <div v-for="item in items" :key="item.id" class="item-card">
        <h3>{{ item.name }}</h3>
        <p>{{ item.description }}</p>
        <p>价格：<strong>{{ item.price }} 星币</strong></p>
        <button @click="buyItem(item.id)">购买</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import request from '../api/request';

const items = ref([]);

// 加载商店列表
const fetchItems = async () => {
  const res = await request.get('/shop');
  items.value = res;
};

// 购买物品
const buyItem = async (itemId) => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (!user) {
    alert('请先登录！');
    return;
  }

  const res = await request.post('/shop', null, {
    params: { userId: user.id, itemId: itemId }
  });

  if (res.code === 0) {
    alert('购买成功！');
  } else {
    alert('购买失败: ' + res.msg);
  }
};

onMounted(fetchItems);
</script>

<style scoped>
.shop-container { padding: 20px; }
.item-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; margin-top: 20px; }
.item-card { border: 1px solid #ccc; padding: 15px; border-radius: 8px; text-align: center; }
button { padding: 8px 16px; background-color: #00d4ff; border: none; border-radius: 4px; cursor: pointer; }
</style>