# send_request.py (WordPress-specific handling)

import requests
import sys

def send_login_request(host, username, password):
    """
    Sends a POST request to a WordPress login endpoint.
    Adjust your host to the URL (excluding the /wp-login.php for clean URL handling).
    Utilizes "wp-login.php" URL structure for WordPress versions.
    """
    login_url = host + "/wp-login.php"

    # Construct the login details payload
    payload = {
        "log": username,
        "pwd": password,
        "reimbrowser": "",
        "rememberme": "forever",
        "wp-submit": "Log In",
        "redirect_to": "",
        "testcookie": "1"
    }

    # Construct headers
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36",
        "Content-Type": "application/x-www-form-urlencoded"
    }

    # Attempt login POST request
    try:
        r = requests.post(login_url, data=payload, headers=headers)
        # Check for 200 OK response. Adjust with the expected status code for successful login.
        if r.status_code == 200:
            print(f"Successful Login for {username} at {host}")
        else:
            print(f"Login failed for {username} at {host} with status code {r.status_code}")
    except requests.exceptions.RequestException as e:
        print(f"Request failed for {username} at {host} with the following exception: {e}")

# Example execution (make sure to replace with actual file paths and host URL)
if __name__ == '__main__':
    if len(sys.argv) != 4:
        print("Usage: python3 send_request.py <host> <username> <password>")
        sys.exit(1)

    host = sys.argv[1]
    username = sys.argv[2]
    password = sys.argv[3]

    send_login_request(host, username, password)