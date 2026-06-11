from fastapi import APIRouter, Depends, HTTPException, status, File, UploadFile
from sqlalchemy.orm import Session
from uuid import uuid4
import os

from app.database import get_db
from app.models import FootballRecord
from app.schemas import FootballRecordResponse, FootballReport
from app.config import settings
from app.services.ai.football_analyzer import FootballAnalyzer

router = APIRouter()

@router.post("/analyze", response_model=FootballRecordResponse)
async def analyze_football(
    user_id: str,
    video: UploadFile = File(...),
    db: Session = Depends(get_db),
):
    # 保存视频文件
    video_path = os.path.join(settings.VIDEO_STORAGE_PATH, f"{uuid4()}.mp4")
    os.makedirs(settings.VIDEO_STORAGE_PATH, exist_ok=True)
    
    with open(video_path, "wb") as f:
        f.write(await video.read())
    
    # 分析视频
    analyzer = FootballAnalyzer()
    result = analyzer.analyze_video(video_path)
    
    # 创建记录
    record = FootballRecord(
        id=str(uuid4()),
        user_id=user_id,
        scene_type=result["scene_type"],
        action_counts=result["action_counts"],
        duration=result["duration"],
        video_url=f"/uploads/videos/{os.path.basename(video_path)}",
        report=result["report"],
    )
    
    db.add(record)
    db.commit()
    db.refresh(record)
    
    return FootballRecordResponse(
        id=record.id,
        user_id=record.user_id,
        scene_type=record.scene_type,
        action_counts=record.action_counts,
        duration=record.duration,
        video_url=record.video_url,
        report=FootballReport(**record.report),
        created_at=record.created_at.isoformat(),
    )

@router.get("/history/{user_id}", response_model=list[FootballRecordResponse])
def get_football_history(user_id: str, db: Session = Depends(get_db)):
    records = db.query(FootballRecord).filter(FootballRecord.user_id == user_id).order_by(FootballRecord.created_at.desc()).all()
    
    return [
        FootballRecordResponse(
            id=record.id,
            user_id=record.user_id,
            scene_type=record.scene_type,
            action_counts=record.action_counts,
            duration=record.duration,
            video_url=record.video_url,
            report=FootballReport(**record.report),
            created_at=record.created_at.isoformat(),
        )
        for record in records
    ]

@router.get("/record/{record_id}", response_model=FootballRecordResponse)
def get_football_record(record_id: str, db: Session = Depends(get_db)):
    record = db.query(FootballRecord).filter(FootballRecord.id == record_id).first()
    
    if not record:
        raise HTTPException(status_code=404, detail="记录不存在")
    
    return FootballRecordResponse(
        id=record.id,
        user_id=record.user_id,
        scene_type=record.scene_type,
        action_counts=record.action_counts,
        duration=record.duration,
        video_url=record.video_url,
        report=FootballReport(**record.report),
        created_at=record.created_at.isoformat(),
    )
