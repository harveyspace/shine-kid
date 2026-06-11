from sqlalchemy import Column, Integer, String, Float, DateTime, JSON
from sqlalchemy.sql import func
from app.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(String(36), primary_key=True, index=True)
    phone = Column(String(20), unique=True, index=True)
    wechat_openid = Column(String(128), unique=True, index=True)
    nickname = Column(String(50), nullable=False)
    avatar = Column(String(500))
    gender = Column(String(10))
    birth_date = Column(DateTime)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class JumpRopeRecord(Base):
    __tablename__ = "jump_rope_records"
    
    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), index=True)
    count = Column(Integer, nullable=False)
    bpm = Column(Integer, nullable=False)
    max_bpm = Column(Integer, nullable=False)
    duration = Column(Integer, nullable=False)
    break_rate = Column(Float, nullable=False)
    video_url = Column(String(500))
    report = Column(JSON)
    created_at = Column(DateTime, default=func.now())

class FootballRecord(Base):
    __tablename__ = "football_records"
    
    id = Column(String(36), primary_key=True, index=True)
    user_id = Column(String(36), index=True)
    scene_type = Column(String(20))
    action_counts = Column(JSON)
    duration = Column(Integer, nullable=False)
    video_url = Column(String(500))
    report = Column(JSON)
    created_at = Column(DateTime, default=func.now())
