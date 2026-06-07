import axios from 'axios';

// 创建 axios 实例
const service = axios.create({
    // 后端接口的基础地址 (假设后端运行在 8080 端口)
    baseURL: 'http://localhost:8080',
    timeout: 5000
});

// 请求拦截器
service.interceptors.request.use(config => {
    // 这里可以统一添加 Token
    return config;
});

// 响应拦截器
service.interceptors.response.use(
    response => {
        return response.data; // 直接返回后端数据
    },
    error => {
        return Promise.reject(error);
    }
);

export default service;