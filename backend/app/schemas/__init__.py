from pydantic import BaseModel, EmailStr
from typing import Optional, Dict

# 用户相关
class UserCreate(BaseModel):
    phone: str
    nickname: str

class UserResponse(BaseModel):
    id: str
    phone: str
    nickname: str
    avatar: Optional[str] = None
    gender: Optional[str] = None
    birth_date: Optional[str] = None
    created_at: str

class UserUpdate(BaseModel):
    nickname: Optional[str] = None
    avatar: Optional[str] = None
    gender: Optional[str] = None
    birth_date: Optional[str] = None

# 认证相关
class LoginRequest(BaseModel):
    phone: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str
    user: UserResponse

# 跳绳相关
class JumpRopeAnalysisRequest(BaseModel):
    video_url: str
    duration: int

class JumpRopeReport(BaseModel):
    overall_score: int
    level: str
    ability_scores: Dict[str, int]
    highlights: list
    suggestions: list

class JumpRopeRecordResponse(BaseModel):
    id: str
    user_id: str
    count: int
    bpm: int
    max_bpm: int
    duration: int
    break_rate: float
    video_url: Optional[str] = None
    report: JumpRopeReport
    created_at: str

# 足球相关
class FootballAnalysisRequest(BaseModel):
    video_url: str

class FootballReport(BaseModel):
    overall_score: int
    level: str
    ability_scores: Dict[str, int]
    highlights: list
    suggestions: list
    skill_details: Optional[Dict[str, int]] = None

class FootballRecordResponse(BaseModel):
    id: str
    user_id: str
    scene_type: Optional[str] = None
    action_counts: Dict[str, int]
    duration: int
    video_url: Optional[str] = None
    report: FootballReport
    created_at: str
