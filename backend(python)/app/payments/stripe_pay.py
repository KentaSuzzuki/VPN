import stripe
import os
from dotenv import load_dotenv
from fastapi import APIRouter

router = APIRouter()
load_dotenv()

stripe.api_key = os.getenv("STRIPE_SECRET_KEY")

@router.post("/create-checkout-session")
async def create_checkout_session():
    session = stripe.checkout.Session.create(
        payment_method_types=['card'],
        line_items=[{
            'price_data': {
                'currency': 'usd',
                'product_data': {'name': 'VPN Premium'},
                'unit_amount': 999,  # $9.99
            },
            'quantity': 1,
        }],
        mode='payment',
        success_url='https://yourfrontend.com/success',
        cancel_url='https://yourfrontend.com/cancel',
    )
    return {"url": session.url}
