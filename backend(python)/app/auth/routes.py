from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from app.db.database import SessionLocal
from app.auth.models import User
from passlib.hash import bcrypt

router = APIRouter()

async def get_db():
    async with SessionLocal() as session:
        yield session

@router.post("/register")
async def register_user(email: str, password: str, db: AsyncSession = Depends(get_db)):
    hashed_pw = bcrypt.hash(password)
    new_user = User(email=email, hashed_password=hashed_pw)
    db.add(new_user)
    await db.commit()
    return {"message": "User registered"}

@router.post("/login")
async def login_user(email: str, password: str, db: AsyncSession = Depends(get_db)):
    result = await db.execute(f"SELECT * FROM users WHERE email = '{email}'")
    user = result.fetchone()
    if user and bcrypt.verify(password, user['hashed_password']):
        return {"message": "Login successful"}
    raise HTTPException(status_code=401, detail="Invalid credentials")