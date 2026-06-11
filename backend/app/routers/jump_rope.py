from fastapi import APIRouter, Depends, HTTPException, status, File, UploadFile
from sqlalchemy.orm import Session
from uuid import uuid4
import os

from app.database import get_db
from app.models import JumpRopeRecord
from app.schemas import JumpRopeRecordResponse, JumpRopeReport
from app.config import settings
from app.services.ai.jump_rope_analyzer import JumpRopeAnalyzer

router = APIRouter()

@router.post("/analyze", response_model=JumpRopeRecordResponse)
async def analyze_jump_rope(
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
    analyzer = JumpRopeAnalyzer()
    result = analyzer.analyze_video(video_path)
    
    # 创建记录
    record = JumpRopeRecord(
        id=str(uuid4()),
        user_id=user_id,
        count=result["count"],
        bpm=result["bpm"],
        max_bpm=result["max_bpm"],
        duration=result["duration"],
        break_rate=result["break_rate"],
        video_url=f"/uploads/videos/{os.path.basename(video_path)}",
        report=result["report"],
    )
    
    db.add(record)
    db.commit()
    db.refresh(record)
    
    return JumpRopeRecordResponse(
        id=record.id,
        user_id=record.user_id,
        count=record.count,
        bpm=record.bpm,
        max_bpm=record.max_bpm,
        duration=record.duration,
        break_rate=record.break_rate,
        video_url=record.video_url,
        report=JumpRopeReport(**record.report),
        created_at=record.created_at.isoformat(),
    )

@router.get("/history/{user_id}", response_model=list[JumpRopeRecordResponse])
def get_jump_rope_history(user_id: str, db: Session = Depends(get_db)):
    records = db.query(JumpRopeRecord).filter(JumpRopeRecord.user_id == user_id).order_by(JumpRopeRecord.created_at.desc()).all()
    
    return [
        JumpRopeRecordResponse(
            id=record.id,
            user_id=record.user_id,
            count=record.count,
            bpm=record.bpm,
            max_bpm=record.max_bpm,
            duration=record.duration,
            break_rate=record.break_rate,
            video_url=record.video_url,
            report=JumpRopeReport(**record.report),
            created_at=record.created_at.isoformat(),
        )
        for record in records
    ]

@router.get("/record/{record_id}", response_model=JumpRopeRecordResponse)
def get_jump_rope_record(record_id: str, db: Session = Depends(get_db)):
    record = db.query(JumpRopeRecord).filter(JumpRopeRecord.id == record_id).first()
    
    if not record:
        raise HTTPException(status_code=404, detail="记录不存在")
    
    return JumpRopeRecordResponse(
        id=record.id,
        user_id=record.user_id,
        count=record.count,
        bpm=record.bpm,
        max_bpm=record.max_bpm,
        duration=record.duration,
        break_rate=record.break_rate,
        video_url=record.video_url,
        report=JumpRopeReport(**record.report),
        created_at=record.created_at.isoformat(),
    )
