from fastapi import FastAPI
from app.routes.vpn_user import router as vpn_router
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()
app.include_router(vpn_router)
