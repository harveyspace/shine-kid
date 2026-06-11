# 闪光少年 - 数据字典

> 版本：v1.1
>
> 日期：2026-06-10

---

## 一、用户相关

### 1.1 用户表 (users)

| 字段名 | 类型 | 长度 | 约束 | 说明 |
|-------|------|-----|-----|------|
| id | VARCHAR | 36 | PRIMARY KEY | 用户唯一标识（UUID） |
| phone | VARCHAR | 20 | UNIQUE | 手机号 |
| wechat_openid | VARCHAR | 128 | UNIQUE | 微信OpenID |
| nickname | VARCHAR | 50 | NOT NULL | 用户昵称 |
| avatar | VARCHAR | 500 | | 头像URL |
| gender | VARCHAR | 10 | | 性别（male/female/other） |
| birth_date | DATE | | | 出生日期（用于年龄计算） |
| created_at | TIMESTAMP | | DEFAULT NOW() | 创建时间 |
| updated_at | TIMESTAMP | | DEFAULT NOW() | 更新时间 |

---

## 二、运动记录相关

### 2.1 跳绳记录表 (jump_rope_records)

| 字段名 | 类型 | 长度 | 约束 | 说明 |
|-------|------|-----|-----|------|
| id | VARCHAR | 36 | PRIMARY KEY | 记录唯一标识 |
| user_id | VARCHAR | 36 | FOREIGN KEY | 所属用户ID |
| count | INT | | NOT NULL | 跳绳次数 |
| bpm | INT | | NOT NULL | 平均BPM |
| max_bpm | INT | | NOT NULL | 最高BPM |
| duration | INT | | NOT NULL | 训练时长（秒） |
| break_rate | FLOAT | | NOT NULL | 断绳率（%） |
| video_url | VARCHAR | 500 | | 视频存储URL |
| report | JSON | | | 六边形报告数据 |
| created_at | TIMESTAMP | | DEFAULT NOW() | 创建时间 |

### 2.2 足球记录表 (football_records)

| 字段名 | 类型 | 长度 | 约束 | 说明 |
|-------|------|-----|-----|------|
| id | VARCHAR | 36 | PRIMARY KEY | 记录唯一标识 |
| user_id | VARCHAR | 36 | FOREIGN KEY | 所属用户ID |
| scene_type | VARCHAR | 20 | | AI识别场景类型（training/match/play） |
| action_counts | JSON | | | 各动作统计 |
| duration | INT | | NOT NULL | 训练时长（秒） |
| video_url | VARCHAR | 500 | | 视频存储URL |
| report | JSON | | | 六边形报告数据 |
| created_at | TIMESTAMP | | DEFAULT NOW() | 创建时间 |

---

## 三、报告数据结构

### 3.1 跳绳能力报告

```json
{
  "overall_score": 78,
  "level": "良好",
  "ability_scores": {
    "explosive": 85,
    "speed": 80,
    "endurance": 70,
    "coordination": 82,
    "flexibility": 65,
    "stability": 76
  },
  "highlights": ["爆发力表现出色", "协调性很好"],
  "suggestions": ["耐力有待提升"]
}
```

### 3.2 足球能力报告

```json
{
  "overall_score": 82,
  "level": "优秀",
  "ability_scores": {
    "explosive": 88,
    "speed": 85,
    "precision": 78,
    "endurance": 80,
    "flexibility": 75,
    "iq": 85
  },
  "highlights": ["爆发力强", "球商高"],
  "suggestions": ["传球精准度需提升"],
  "skill_details": {
    "pass_accuracy": 72,
    "shoot_accuracy": 85,
    "dribble_success": 88,
    "trap_quality": 78
  }
}
```

### 3.3 能力维度说明

#### 跳绳维度

| 维度码 | 名称 | 说明 |
|-------|------|-----|
| explosive | 爆发力 | 腾空高度、启动速度 |
| speed | 速度 | 平均速度、最高速度 |
| endurance | 耐力 | 持续时间、疲劳指数 |
| coordination | 协调性 | 动作节奏稳定性 |
| flexibility | 柔韧性 | 关节活动范围 |
| stability | 稳定性 | 重心控制、平衡 |

#### 足球维度

| 维度码 | 名称 | 说明 |
|-------|------|-----|
| explosive | 爆发力 | 冲刺速度、启动爆发力、变向加速 |
| speed | 速度 | 带球速度、无球跑动速度、反应速度 |
| precision | 精准 | 传球成功率、射门准确率、传中精度 |
| endurance | 耐力 | 跑动距离、高强度跑占比、恢复能力 |
| flexibility | 柔韧 | 髋关节活动度、身体协调性 |
| iq | 球商 | 视野宽度、决策速度、位置感 |

---

## 四、枚举值定义

### 4.1 训练模式（跳绳）

| 值 | 说明 |
|-----|------|
| timed_10s | 计时10秒 |
| timed_30s | 计时30秒 |
| timed_1min | 计时1分钟 |

### 4.2 场景类型（足球）

| 值 | 说明 |
|-----|------|
| training | 训练 |
| match | 比赛 |
| play | 自由玩耍 |

### 4.3 动作类型（足球AI识别）

| 值 | 说明 |
|-----|------|
| balance | 颠球 |
| dribble | 带球 |
| shoot | 射门 |
| pass | 传球 |
| defense | 防守 |

### 4.3 能力等级

| 等级 | 分数范围 | 说明 |
|-----|---------|------|
| 卓越 | 90-100 | 优秀表现 |
| 优秀 | 80-89 | 良好表现 |
| 良好 | 70-79 | 中等偏上 |
| 合格 | 60-69 | 达标 |
| 待提升 | <60 | 需要改进 |

---

## 五、API响应结构

### 5.1 成功响应

```json
{
  "code": 200,
  "message": "success",
  "data": {...}
}
```

### 5.2 错误响应

```json
{
  "code": 400,
  "message": "参数错误",
  "detail": "具体错误描述"
}
```

---

*文档版本：v1.1*
*最后更新：2026-06-10*
