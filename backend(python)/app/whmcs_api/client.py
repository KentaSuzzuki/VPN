import requests
import os

WHMCS_URL = os.getenv("WHMCS_API_URL")
API_IDENTIFIER = os.getenv("WHMCS_API_IDENTIFIER")
API_SECRET = os.getenv("WHMCS_API_SECRET")

def get_client_by_email(email: str):
    payload = {
        'identifier': API_IDENTIFIER,
        'secret': API_SECRET,
        'action': 'GetClientsDetails',
        'email': email,
        'stats': True
    }
    response = requests.post(WHMCS_URL, data=payload)
    return response.json()

def has_paid_invoice(user_id: str):
    payload = {
        'identifier': API_IDENTIFIER,
        'secret': API_SECRET,
        'action': 'GetInvoices',
        'userid': user_id,
        'status': 'Paid'
    }
    response = requests.post(WHMCS_URL, data=payload)
    data = response.json()
    return len(data.get("invoices", {}).get("invoice", [])) > 0