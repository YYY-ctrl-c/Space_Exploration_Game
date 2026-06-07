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
import { useUser } from '../status/useUser';

const { user, updateCoins } = useUser();
const items = ref([]); // 这个数组用来存数据

// 【修改处】补全获取数据的逻辑
const fetchItems = async () => {
  try {
    const res = await request.get('/shop'); // 发送 GET 请求
    // 假设后端直接返回了商品数组
    items.value = res;
  } catch (error) {
    console.error("加载商店列表失败:", error);
  }
};

const buyItem = async (itemId) => {
  if (!user.value) {
    alert('请先登录！');
    return;
  }

  const res = await request.post('/shop', null, {
    params: { userId: user.value.id, itemId: itemId }
  });

  if (res.code === 0) {
    alert('购买成功！');
    if (res.data && res.data.newCoins !== undefined) {
      updateCoins(res.data.newCoins); // 更新全局状态
    }
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