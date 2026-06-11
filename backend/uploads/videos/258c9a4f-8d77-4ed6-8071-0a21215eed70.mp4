from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.routers import auth, users, jump_rope, football
from app.database import engine, Base

# 创建数据库表
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="闪光少年 API",
    description="AI运动能力分析平台",
    version="1.0.0",
)

# CORS配置
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 挂载静态文件
app.mount("/uploads", StaticFiles(directory="uploads"), name="uploads")

# 注册路由
app.include_router(auth.router, prefix="/api/v1/auth", tags=["Auth"])
app.include_router(users.router, prefix="/api/v1/users", tags=["Users"])
app.include_router(jump_rope.router, prefix="/api/v1/jump-rope", tags=["Jump Rope"])
app.include_router(football.router, prefix="/api/v1/football", tags=["Football"])

@app.get("/")
def read_root():
    return {"message": "欢迎使用闪光少年 API"}
