#!/usr/bin/env python3
"""
OAuth2 token management for Mutt/Neomutt with Gmail
Based on: https://github.com/neomutt/neomutt/blob/main/contrib/oauth2/mutt_oauth2.py

This script helps obtain and refresh OAuth2 tokens for Gmail.
"""

import sys
import json
import urllib.parse
import urllib.request
import time
import base64
import os
from pathlib import Path

# Gmail OAuth2 endpoints
GOOGLE_TOKEN_ENDPOINT = 'https://oauth2.googleapis.com/token'
GOOGLE_DEVICE_CODE_ENDPOINT = 'https://oauth2.googleapis.com/device/code'

# You'll need to register your own app at: https://console.cloud.google.com/
# Or use the public client ID below (less secure, may be rate limited)
# For personal use, you should create your own OAuth app
CLIENT_ID = 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com'
CLIENT_SECRET = 'YOUR_CLIENT_SECRET_HERE'

SCOPES = 'https://mail.google.com/'

def register_app():
    """Instructions for registering a Google Cloud OAuth app"""
    print("""
===================================================================
GMAIL OAUTH2 SETUP INSTRUCTIONS
===================================================================

Since app passwords are disabled, you need to use OAuth2. This requires
registering an OAuth application with Google Cloud Console.

STEPS TO REGISTER YOUR OAUTH APP:
===================================================================

1. Go to: https://console.cloud.google.com/

2. Create a new project (or select existing):
   - Click "Select a project" → "New Project"
   - Name it something like "Neomutt Mail Client"
   - Click "Create"

3. Enable Gmail API:
   - Go to "APIs & Services" → "Library"
   - Search for "Gmail API"
   - Click "Enable"

4. Configure OAuth Consent Screen:
   - Go to "APIs & Services" → "OAuth consent screen"
   - Choose "External" (unless you have Google Workspace)
   - Fill in:
     * App name: "Neomutt Mail"
     * User support email: your email
     * Developer contact: your email
   - Click "Save and Continue"
   - Scopes: Click "Add or Remove Scopes"
     * Search for "https://mail.google.com/"
     * Select it and click "Update"
   - Test users: Add your work email address
   - Click "Save and Continue"

5. Create OAuth Client ID:
   - Go to "APIs & Services" → "Credentials"
   - Click "Create Credentials" → "OAuth client ID"
   - Application type: "Desktop app"
   - Name: "Neomutt Client"
   - Click "Create"
   - **COPY THE CLIENT ID AND CLIENT SECRET**

6. Update this script:
   - Edit: ~/.config/neomutt/mutt_oauth2.py
   - Replace CLIENT_ID and CLIENT_SECRET with your values

7. Run this script to get tokens:
   python3 ~/.config/neomutt/mutt_oauth2.py --authorize

===================================================================
""")

def get_device_code():
    """Get device code for OAuth2 device flow"""
    data = urllib.parse.urlencode({
        'client_id': CLIENT_ID,
        'scope': SCOPES
    }).encode()

    req = urllib.request.Request(GOOGLE_DEVICE_CODE_ENDPOINT, data=data)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode())

def poll_for_token(device_code):
    """Poll for access token"""
    data = urllib.parse.urlencode({
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'device_code': device_code,
        'grant_type': 'urn:ietf:params:oauth:grant-type:device_code'
    }).encode()

    while True:
        try:
            req = urllib.request.Request(GOOGLE_TOKEN_ENDPOINT, data=data)
            with urllib.request.urlopen(req) as response:
                return json.loads(response.read().decode())
        except urllib.error.HTTPError as e:
            error_data = json.loads(e.read().decode())
            if error_data.get('error') == 'authorization_pending':
                time.sleep(5)
                continue
            raise

def refresh_token(refresh_token_val):
    """Refresh an expired access token"""
    data = urllib.parse.urlencode({
        'client_id': CLIENT_ID,
        'client_secret': CLIENT_SECRET,
        'refresh_token': refresh_token_val,
        'grant_type': 'refresh_token'
    }).encode()

    req = urllib.request.Request(GOOGLE_TOKEN_ENDPOINT, data=data)
    with urllib.request.urlopen(req) as response:
        return json.loads(response.read().decode())

def save_tokens(tokens, token_file):
    """Save tokens to file"""
    token_file.parent.mkdir(parents=True, exist_ok=True)
    with open(token_file, 'w') as f:
        json.dump(tokens, f, indent=2)
    os.chmod(token_file, 0o600)

def load_tokens(token_file):
    """Load tokens from file"""
    if not token_file.exists():
        return None
    with open(token_file) as f:
        return json.load(f)

def authorize(token_file):
    """Perform initial OAuth2 authorization"""
    if CLIENT_ID == 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com':
        register_app()
        sys.exit(1)

    print("Starting OAuth2 authorization...")
    device_info = get_device_code()

    print(f"\n{'='*60}")
    print(f"Go to: {device_info['verification_url']}")
    print(f"Enter code: {device_info['user_code']}")
    print(f"{'='*60}\n")

    print("Waiting for authorization...")
    tokens = poll_for_token(device_info['device_code'])
    tokens['expires_at'] = time.time() + tokens['expires_in']

    save_tokens(tokens, token_file)
    print(f"\n✓ Authorization successful! Tokens saved to: {token_file}")
    return tokens

def get_access_token(token_file):
    """Get a valid access token, refreshing if necessary"""
    tokens = load_tokens(token_file)

    if not tokens:
        print("No tokens found. Run with --authorize first.", file=sys.stderr)
        sys.exit(1)

    # Check if token is expired (with 60 second buffer)
    if tokens.get('expires_at', 0) < time.time() + 60:
        tokens = refresh_token(tokens['refresh_token'])
        tokens['expires_at'] = time.time() + tokens['expires_in']
        tokens['refresh_token'] = load_tokens(token_file)['refresh_token']  # Keep old refresh token
        save_tokens(tokens, token_file)

    return tokens['access_token']

def main():
    token_file = Path.home() / '.config' / 'neomutt' / 'oauth2_tokens.json'

    if len(sys.argv) > 1 and sys.argv[1] == '--authorize':
        authorize(token_file)
    else:
        # Output access token for neomutt to use
        access_token = get_access_token(token_file)
        print(access_token)

if __name__ == '__main__':
    main()
