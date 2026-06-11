# 闪光少年 - 技术设计文档 (TDD)

> 版本：v1.0
>
> 日期：2026-06-10

---

## 一、架构概述

### 1.1 整体架构

```
┌─────────────────────────────────────────────────────────┐
│                      移动端 App                          │
│                    Flutter (iOS + Android)              │
├─────────────────────────────────────────────────────────┤
│                      API Gateway                         │
│                       Nginx / 本地                       │
├─────────────────────────────────────────────────────────┤
│              ┌─────────┬─────────┬─────────┐           │
│              ▼         ▼         ▼         │           │
│         ┌────────┐ ┌───────┐ ┌────────┐   │           │
│         │  Auth  │ │ User  │ │ Sports │   │           │
│         │ Service│ │Service│ │ Service│   │           │
│         └───┬────┘ └───┬───┘ └───┬────┘   │           │
│             │          │         │         │           │
│             ▼          ▼         ▼         │           │
│         ┌──────────────────────────────┐   │           │
│         │         PostgreSQL          │   │           │
│         └──────────────────────────────┘   │           │
│                                            │           │
│              ┌──────────────────────────────┘           │
│              ▼                                         │
│         ┌─────────────────────────────────────────┐     │
│         │              AI Engine                   │     │
│         │  MediaPipe Pose + TensorFlow Lite       │     │
│         │  Jump Rope Analyzer + Football Analyzer │     │
│         └─────────────────────────────────────────┘     │
└─────────────────────────────────────────────────────────┘
```

### 1.2 架构原则

| 原则 | 说明 |
|-----|------|
| **分层架构** | UI层、业务层、数据层分离 |
| **模块化** | 功能解耦，便于扩展 |
| **端云协同** | 端侧实时处理 + 云端二次校验 |
| **隐私优先** | 视频数据本地处理，不上传原始数据 |

---

## 二、技术栈

### 2.1 移动端

| 技术 | 版本 | 说明 |
|-----|------|-----|
| Flutter | 3.19+ | 跨平台框架，丝滑体验 |
| Riverpod | 2.4+ | 状态管理 |
| GoRouter | 13+ | 路由管理 |
| Camera | 0.10+ | 摄像头访问 |
| VideoPlayer | 2.8+ | 视频播放 |
| tflite_flutter | 0.10+ | 端侧AI推理 |

### 2.2 后端

| 技术 | 版本 | 说明 |
|-----|------|-----|
| FastAPI | 0.110+ | 高性能API框架 |
| Python | 3.11+ | 开发语言 |
| SQLAlchemy | 2.0+ | ORM |
| PostgreSQL | 16+ | 数据库 |
| Redis | 7+ | 缓存 |
| MediaPipe | 0.10+ | AI姿态检测 |

### 2.3 开发工具

| 工具 | 用途 |
|-----|------|
| Git | 版本控制 |
| Docker | 容器化 |
| Pytest | 测试框架 |
| Black | 代码格式化 |

---

## 三、API设计

### 3.1 认证接口

| 接口 | 方法 | 说明 |
|-----|------|-----|
| `/api/v1/auth/login` | POST | 手机号登录 |
| `/api/v1/auth/wechat` | POST | 微信登录 |

#### 请求示例

```json
// POST /api/v1/auth/login
{
  "phone": "13800138000"
}
```

#### 响应示例

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "user": {
    "id": "uuid-string",
    "phone": "13800138000",
    "nickname": "用户8000",
    "avatar": null,
    "created_at": "2024-01-01T12:00:00Z"
  }
}
```

### 3.2 用户接口

| 接口 | 方法 | 说明 |
|-----|------|-----|
| `/api/v1/user/profile` | GET | 获取用户信息 |
| `/api/v1/user/profile` | PUT | 更新用户信息 |
| `/api/v1/user/children` | GET | 获取孩子列表 |
| `/api/v1/user/children` | POST | 添加孩子 |
| `/api/v1/user/children/{id}` | PUT | 更新孩子信息 |

### 3.3 跳绳接口

| 接口 | 方法 | 说明 |
|-----|------|-----|
| `/api/v1/jump-rope/analyze` | POST | 上传视频分析 |
| `/api/v1/jump-rope/history` | GET | 获取历史记录 |
| `/api/v1/jump-rope/report/{id}` | GET | 获取报告 |

### 3.4 足球接口

| 接口 | 方法 | 说明 |
|-----|------|-----|
| `/api/v1/football/analyze` | POST | 上传视频分析 |
| `/api/v1/football/history` | GET | 获取历史记录 |
| `/api/v1/football/report/{id}` | GET | 获取报告 |

---

## 四、数据库设计

### 4.1 用户表 (users)

| 字段 | 类型 | 约束 | 说明 |
|-----|------|-----|------|
| id | VARCHAR(36) | PRIMARY KEY | UUID |
| phone | VARCHAR(20) | UNIQUE | 手机号 |
| wechat_openid | VARCHAR(128) | UNIQUE | 微信OpenID |
| nickname | VARCHAR(50) | NOT NULL | 昵称 |
| avatar | VARCHAR(500) | | 头像URL |
| gender | VARCHAR(10) | | 性别 |
| birth_date | DATE | | 出生日期（用于年龄计算） |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |
| updated_at | TIMESTAMP | DEFAULT NOW() | 更新时间 |

### 4.2 跳绳记录表 (jump_rope_records)

| 字段 | 类型 | 约束 | 说明 |
|-----|------|-----|------|
| id | VARCHAR(36) | PRIMARY KEY | UUID |
| user_id | VARCHAR(36) | FOREIGN KEY | 所属用户 |
| count | INT | NOT NULL | 跳绳次数 |
| bpm | INT | NOT NULL | 平均BPM |
| max_bpm | INT | NOT NULL | 最高BPM |
| duration | INT | NOT NULL | 时长(秒) |
| break_rate | FLOAT | NOT NULL | 断绳率(%) |
| video_url | VARCHAR(500) | | 视频URL |
| report | JSON | | 六边形报告 |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |

### 4.3 足球记录表 (football_records)

| 字段 | 类型 | 约束 | 说明 |
|-----|------|-----|------|
| id | VARCHAR(36) | PRIMARY KEY | UUID |
| user_id | VARCHAR(36) | FOREIGN KEY | 所属用户 |
| scene_type | VARCHAR(20) | | AI识别场景类型（training/match/play） |
| action_counts | JSON | | 各动作统计（颠球/带球/传球/射门/防守次数） |
| duration | INT | NOT NULL | 时长(秒) |
| video_url | VARCHAR(500) | | 视频URL |
| report | JSON | | 六边形报告 |
| created_at | TIMESTAMP | DEFAULT NOW() | 创建时间 |

---

## 五、AI算法设计

### 5.1 跳绳计数算法

```
输入：视频帧序列
输出：跳绳次数、BPM、断绳率

流程：
1. 帧预处理 → 人体姿态检测（MediaPipe Pose）
2. 关键点提取 → 脚踝、膝盖、髋部、手腕
3. 动作分析 → 
   - 检测双脚同时离地（腾空）
   - 检测手臂圆周运动
   - 计数逻辑：连续腾空判定为一次跳绳
4. 统计计算 → BPM、断绳率、能力评分
```

### 5.2 足球动作识别

```
输入：视频帧序列、训练类型
输出：动作次数、能力评分

流程：
1. 帧预处理 → 人体姿态检测 + 目标检测（球）
2. 动作分类 → 
   - 颠球：球与脚接触计数
   - 带球：球与脚持续接触 + 位移
   - 射门：脚踢球动作 + 球飞行轨迹
3. 统计计算 → 动作次数、成功率、能力评分
```

### 5.3 六边形能力计算

| 维度 | 跳绳计算方式 | 足球计算方式 |
|-----|-------------|-------------|
| 爆发力 | max_bpm * 0.8 + 20 | 冲刺速度评分 |
| 速度 | bpm * 0.7 + 20 | 带球速度评分 |
| 耐力 | duration/60 * 15 + 50 - break_rate | 跑动距离评分 |
| 协调性 | 100 - break_rate * 3 | 动作稳定性评分 |
| 柔韧性 | 基于关节角度 | 髋关节活动度 |
| 稳定性 | 100 - break_rate * 5 | 控球稳定性 |

---

## 六、项目结构

### 6.1 Flutter项目结构

```
flutter_app/
├── lib/
│   ├── main.dart           # 入口
│   ├── app.dart            # 根组件
│   ├── core/               # 核心模块
│   │   ├── constants/      # 常量配置
│   │   ├── theme/          # 主题配置
│   │   ├── utils/          # 工具函数
│   │   └── widgets/        # 通用组件
│   ├── data/               # 数据层
│   │   ├── models/         # 数据模型
│   │   ├── repositories/   # 数据仓库
│   │   └── providers/      # 状态管理
│   ├── services/           # 服务层
│   │   ├── api_service.dart    # API服务
│   │   ├── auth_service.dart   # 认证服务
│   │   └── ai_service.dart     # AI服务
│   ├── features/           # 功能模块
│   │   ├── home/           # 首页
│   │   ├── jump_rope/      # 跳绳
│   │   ├── football/       # 足球
│   │   ├── report/         # 报告
│   │   └── profile/        # 个人中心
│   └── routes/             # 路由配置
├── assets/                 # 资源文件
├── pubspec.yaml            # 依赖配置
└── ios/android/            # 平台特定代码
```

### 6.2 后端项目结构

```
backend/
├── app/
│   ├── main.py             # 入口
│   ├── config.py           # 配置管理
│   ├── database.py         # 数据库配置
│   ├── models/             # SQLAlchemy模型
│   ├── schemas/            # Pydantic Schema
│   ├── routers/            # 路由定义
│   ├── services/           # 业务服务
│   │   └── ai/             # AI服务
│   │       ├── pose_detector.py
│   │       ├── jump_rope_analyzer.py
│   │       └── football_analyzer.py
│   └── utils/              # 工具函数
├── requirements.txt        # 依赖清单
├── .env                    # 环境变量
└── docker-compose.yml      # Docker配置
```

---

## 七、安全设计

### 7.1 数据安全

| 措施 | 说明 |
|-----|------|
| HTTPS | 所有接口使用HTTPS |
| JWT认证 | 无状态认证 |
| 视频加密 | 上传视频加密存储 |
| 最小权限 | 数据库用户最小权限 |

### 7.2 隐私保护

| 措施 | 说明 |
|-----|------|
| 端侧处理 | 视频本地AI分析，不上传原始数据 |
| 用户授权 | 明确告知数据用途 |
| 数据脱敏 | 敏感信息脱敏存储 |
| 删除机制 | 用户可删除数据 |

---

## 八、部署方案

### 8.1 开发环境

```
本地开发：
├── Flutter App → 模拟器/真机
├── 后端 → 本地FastAPI
├── 数据库 → Docker PostgreSQL
└── Redis → Docker Redis
```

### 8.2 测试环境

```
测试服务器：
├── Flutter App → TestFlight/Google Play测试版
├── 后端 → 测试服务器
├── 数据库 → 测试数据库
└── Redis → 测试缓存
```

### 8.3 生产环境

```
生产服务器：
├── Flutter App → App Store/Google Play
├── 后端 → 云服务器ECS
├── 数据库 → 云数据库RDS
├── Redis → 云缓存
└── CDN → 静态资源加速
```

---

## 九、性能优化

### 9.1 移动端优化

| 优化项 | 措施 |
|-----|------|
| 启动速度 | 懒加载、骨架屏 |
| 内存管理 | 图片缓存、资源释放 |
| 动画流畅 | 60fps、避免阻塞主线程 |
| 网络优化 | 请求合并、缓存策略 |

### 9.2 后端优化

| 优化项 | 措施 |
|-----|------|
| 数据库 | 索引优化、查询缓存 |
| API性能 | 异步处理、连接池 |
| AI推理 | 模型优化、批量处理 |

---

*文档版本：v1.0*
*最后更新：2026-06-10*
