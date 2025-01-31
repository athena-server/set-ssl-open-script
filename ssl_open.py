import argparse
import os
from dotenv import load_dotenv
import requests

def main():
    load_dotenv()
    BACKEND_URL = os.environ.get('BACKEND_URL')
    
    if not BACKEND_URL:
        print("Error: BACKEND_URL is not set in environment variables.")
        return
    
    parser = argparse.ArgumentParser(description="Take admin credentials and SSL Open status")
    parser.add_argument("--username", type=str, required=True, help="Username as set in db")
    parser.add_argument("--password", type=str, required=True, help="Password as set in db")
    parser.add_argument("--open", type=str, choices=["true", "True", "false", "False"],  required=True, help="State to set the SSL open state to (True / False)")
    
    args = parser.parse_args()
    
    username = args.username
    password = args.password
    open_state = True if str(args.open).lower() == "true" else False 
    
    try:
        auth_response = requests.post(f'{BACKEND_URL}/api/auth/local', json={
            "identifier": username,
            "password": password
        })    
        auth_response.raise_for_status()
        jwt_token = auth_response.json().get('jwt')
        
        if not jwt_token:
            print("Error: Authentication failed. No JWT token received.")
            return
    except requests.RequestException as e:
        print(f"Error: Authentication request failed - {e}")
        return
    
    try:
        set_ssl_open_response = requests.put(f'{BACKEND_URL}/api/is-ssl-open', json={
            "data": {
                "current_status": open_state
            }
        }, headers={
            "Authorization": f'Bearer {jwt_token}'
        })
        set_ssl_open_response.raise_for_status()
        print("Status updated successfully")
    except requests.RequestException as e:
        print(f"Error: Failed to update SSL open state - {e}")

if __name__ == '__main__':
    main()