from python_wireguard import Key, Server, ClientConnection
import os

# 🔐 Generate a public/private key pair
def generate_keys():
    private_key, public_key = Key.key_pair()
    return {
        "private_key": str(private_key),
        "public_key": str(public_key)
    }

# 👤 Create a peer config (ClientConnection)
def create_peer_config(public_key: str, allowed_ip: str):
    try:
        peer_key = Key(public_key)
        return ClientConnection(peer_key, allowed_ip)
    except Exception as e:
        raise ValueError(f"Invalid public key: {e}")

# 🧠 Build full WireGuard config file with server + one or many peers
def build_config(private_key: str, peers=None, address=None, port=None):
    address = address or os.getenv("WG_ADDRESS", "10.0.0.1/24")
    port = int(port or os.getenv("WG_PORT", "51820"))

    try:
        server_key = Key(private_key)
    except Exception as e:
        raise ValueError(f"Invalid private key: {e}")

    server = Server("wg0", server_key, address, port)

    if peers:
        if isinstance(peers, list):
            for peer in peers:
                server.add_client(peer)
        else:
            server.add_client(peers)

    return server

# 💾 Write WireGuard config to .conf file
def write_config_file(server: Server, path: str):
    try:
        with open(path, "w") as f:
            f.write(str(server))
    except Exception as e:
        raise IOError(f"Failed to write WireGuard config: {e}")
