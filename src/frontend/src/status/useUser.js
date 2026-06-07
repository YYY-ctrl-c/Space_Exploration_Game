import { ref } from 'vue';

// 创建一个全局的响应式引用，初始值从 sessionStorage 读取
const user = ref(JSON.parse(sessionStorage.getItem('user')));

export function useUser() {
    // 更新用户信息的方法
    const setUser = (newUser) => {
        user.value = newUser;
        if (newUser) {
            sessionStorage.setItem('user', JSON.stringify(newUser));
        } else {
            sessionStorage.removeItem('user');
        }
    };

    // 更新特定字段（比如金币）的方法
    const updateCoins = (newCoins) => {
        if (user.value) {
            user.value.coins = newCoins;
            // 必须同步更新 sessionStorage
            sessionStorage.setItem('user', JSON.stringify(user.value));
        }
    };

    return { user, setUser, updateCoins };
}