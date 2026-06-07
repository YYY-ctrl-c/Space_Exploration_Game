<template>
  <div class="inventory-container">
    <h2>我的物资货舱</h2>
    <div class="item-list">
      <div v-for="item in items" :key="item.id" class="item-box">
        <h4>{{ item.name }}</h4>
        <p>数量：{{ item.amount }}</p>
        <small>{{ item.desc }}</small>
      </div>
      <div v-if="items.length === 0" class="empty">货舱目前为空，快去探索吧！</div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import request from '../api/request';

const items = ref([]);

const fetchInventory = async () => {
  const user = JSON.parse(localStorage.getItem('user'));
  if (!user) return;

  // 调用 ItemServlet
  const res = await request.get('/items', { params: { userId: user.id } });
  items.value = res;
};

onMounted(fetchInventory);
</script>

<style scoped>
.inventory-container { padding: 20px; }
.item-list { display: flex; flex-wrap: wrap; gap: 15px; margin-top: 20px; }
.item-box { border: 1px solid #00d4ff; padding: 15px; border-radius: 8px; width: 150px; text-align: center; }
.empty { color: #888; margin-top: 20px; }
</style>