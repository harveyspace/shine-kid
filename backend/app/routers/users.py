from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from datetime import datetime

from app.database import get_db
from app.models import User
from app.schemas import UserResponse, UserUpdate

router = APIRouter()

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: str, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    return UserResponse(
        id=user.id,
        phone=user.phone,
        nickname=user.nickname,
        avatar=user.avatar,
        gender=user.gender,
        birth_date=user.birth_date.isoformat() if user.birth_date else None,
        created_at=user.created_at.isoformat(),
    )

@router.put("/{user_id}", response_model=UserResponse)
def update_user(user_id: str, request: UserUpdate, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="用户不存在")
    
    if request.nickname is not None:
        user.nickname = request.nickname
    if request.avatar is not None:
        user.avatar = request.avatar
    if request.gender is not None:
        user.gender = request.gender
    if request.birth_date is not None:
        user.birth_date = datetime.fromisoformat(request.birth_date)
    
    db.commit()
    db.refresh(user)
    
    return UserResponse(
        id=user.id,
        phone=user.phone,
        nickname=user.nickname,
        avatar=user.avatar,
        gender=user.gender,
        birth_date=user.birth_date.isoformat() if user.birth_date else None,
        created_at=user.created_at.isoformat(),
    )
