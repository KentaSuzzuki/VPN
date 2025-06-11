from fastapi import APIRouter, HTTPException, Body
from app.whmcs_api import client as whmcs
from app.wireguard_api import wg
import os
# import json

router = APIRouter()

CONFIG_PATH = os.getenv("WG_CONFIG_PATH", "wg0.conf")

# Store all peers in memory (optional: persist in DB)
peers_db = {}

@router.post("/create-vpn-config")
def create_vpn_config(email: str = Body(...), public_key: str = Body(...)):
    user = whmcs.get_client_by_email(email)
    if user.get("result") != "success":
        raise HTTPException(status_code=404, detail="User not found")

    user_id = user["userid"]
    if not whmcs.has_paid_invoice(user_id):
        raise HTTPException(status_code=403, detail="No paid invoices")

    # Peer setup
    peer_ip = f"10.0.0.{int(user_id)+1}/32"
    peer = wg.create_peer_config(public_key, peer_ip)
    keys = wg.generate_keys()
    server = wg.build_config(private_key=keys["private_key"], peer=peer)
    wg.write_config_file(server, CONFIG_PATH)

    # Store peer info
    peers_db[user_id] = {
        "email": email,
        "peer_ip": peer_ip,
        "public_key": public_key,
        "private_key": keys["private_key"],
        "server_public_key": keys["public_key"]
    }

    return {
        "vpn_access": True,
        "peer_ip": peer_ip,
        "private_key": keys["private_key"],
        "server_public_key": keys["public_key"],
        "server_endpoint": "yourvpn.example.com:51820"
    }

@router.post("/disconnect")
def disconnect_peer(user_id: str = Body(...)):
    if user_id not in peers_db:
        raise HTTPException(status_code=404, detail="Peer not found")

    del peers_db[user_id]

    # Rebuild config without the removed peer
    keys = wg.generate_keys()
    remaining_peers = [
        wg.create_peer_config(peer["public_key"], peer["peer_ip"])
        for uid, peer in peers_db.items()
    ]
    server = wg.build_config(private_key=keys["private_key"], peers=remaining_peers)
    wg.write_config_file(server, CONFIG_PATH)

    return {"disconnected": True}

@router.get("/status")
def get_vpn_status():
    try:
        with open(CONFIG_PATH, "r") as f:
            return {"status": "online", "config": f.read()}
    except Exception:
        return {"status": "offline", "config": None}

@router.get("/list-peers")
def list_peers():
    return peers_db
