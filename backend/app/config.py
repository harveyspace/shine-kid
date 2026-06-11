from pydantic_settings import BaseSettings
from dotenv import load_dotenv
import os

load_dotenv()

class Settings(BaseSettings):
    # 数据库配置
    DATABASE_URL: str = os.getenv("DATABASE_URL")
    REDIS_URL: str = os.getenv("REDIS_URL")
    
    # JWT配置
    SECRET_KEY: str = os.getenv("SECRET_KEY")
    ALGORITHM: str = os.getenv("ALGORITHM", "HS256")
    ACCESS_TOKEN_EXPIRE_MINUTES: int = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "30"))
    
    # 服务器配置
    HOST: str = os.getenv("HOST", "0.0.0.0")
    PORT: int = int(os.getenv("PORT", "8000"))
    
    # 视频存储配置
    VIDEO_STORAGE_PATH: str = os.getenv("VIDEO_STORAGE_PATH", "./uploads/videos")
    MAX_VIDEO_SIZE: int = int(os.getenv("MAX_VIDEO_SIZE", "1073741824"))
    
    # AI模型配置
    MODEL_PATH: str = os.getenv("MODEL_PATH", "./models")

settings = Settings()
