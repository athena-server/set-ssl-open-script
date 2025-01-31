# SSL Open Status Management

This project provides two scripts (`ssl_open.py` and `ssl_open.sh`) to manage the SSL open state via a backend API.

## Prerequisites
- Python 3.x (for `ssl_open.py`)
- Bash (for `ssl_open.sh`)
- `requests` and `python-dotenv` installed for Python script:
  ```sh
  pip install -r requirements.txt
  ```
- `jq` installed for Bash script (used for parsing JSON response):
  ```sh
  sudo apt install jq  # Debian/Ubuntu
  brew install jq      # macOS
  ```

## Environment Variables
Create a `.env` file in the same directory as the scripts and define:
```
BACKEND_URL=<your_backend_url>
```

## Usage
### Using `ssl_open.py`
```sh
python ssl_open.py --username <username> --password <password> --open <true|false>
```
#### Example:
```sh
python ssl_open.py --username admin --password admin123 --open true
```

### Using `ssl_open.sh`
Make the script executable:
```sh
chmod +x ssl_open.sh
```
Run the script:
```sh
./ssl_open.sh --username <username> --password <password> --open <true|false>
```
#### Example:
```sh
./ssl_open.sh --username admin --password admin123 --open false
```
