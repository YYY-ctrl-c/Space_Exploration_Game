<template>
  <div class="crew-container">
    <h2>舰员指挥中心</h2>
    <div v-for="crew in crewList" :key="crew.id" class="crew-card">
      <p>代号：{{ crew.nickname }}</p>
      <p>状态：{{ crew.fatigue }}/{{ crew.fatigueMax }} (疲劳度)</p>
      <div class="recovery-section">
        <select v-model="selectedItem[crew.id]">
          <option v-for="item in getAvailableItems(crew)" :key="item.id" :value="item.id">
            {{ item.name }} x{{ item.amount }} (恢复 {{ item.supplyPower }} 疲劳)
          </option>
        </select>
        <button @click="restCrew(crew.id, selectedItem[crew.id])">补充能量</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import {ref, onMounted} from 'vue';
import request from '../api/request';
import {useUser} from '../status/useUser';

const {user} = useUser();
const crewList = ref([]);
const items = ref([]);
const selectedItem = ref({});

const fetchCrews = async () => {
  const res = await request.get('/crew', {params: {userId: user.value.id}});
  crewList.value = res;
};

const fetchItems = async () => {
  const itemsRes = await request.get('/items', {params: {userId: user.value.id}});
  const shopRes = await request.get('/shop');
  const powerMap = new Map();
  shopRes.forEach(s => {
    if (s.supplyPower > 0) powerMap.set(s.id, s.supplyPower);
  });
  items.value = itemsRes
      .filter(i => powerMap.has(i.id))
      .map(i => ({...i, supplyPower: powerMap.get(i.id)}));
};

const getAvailableItems = (crew) => {
  return items.value.filter(item => {
    if (item.amount <= 0) return false;
    if (item.id === 16) return true;
    if (item.id >= 1 && item.id <= 15 && item.id === crew.crewId) return true;
    return false;
  });
};

const restCrew = async (crewId, itemId) => {
  if (!itemId) {
    alert('请选择恢复物品');
    return;
  }
  const res = await request.post('/crew', null, { params: { crewId, itemId } });
  if (res.code === 0) {
    alert('能量补充完毕！');
    // 清空所选物品
    selectedItem.value[crewId] = null;
    await fetchCrews();
    await fetchItems();
  } else {
    alert('补充失败: ' + res.msg);
  }
};

onMounted(async () => {
  await fetchCrews();
  await fetchItems();
});
</script>

<style scoped>
.crew-card {
  border: 1px solid #444;
  padding: 10px;
  margin: 10px;
  border-radius: 8px;
}

.recovery-section {
  margin-top: 10px;
  display: flex;
  gap: 10px;
  align-items: center;
}

select {
  padding: 5px;
}

button {
  padding: 5px 10px;
  background-color: #00d4ff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}
</style>