# Quick Guide: Work Email OAuth2 Setup

Follow these steps to set up your work Gmail with OAuth2 (for accounts with SSO/MFA like JumpCloud).

## Step 1: Register Google Cloud OAuth App (10 minutes)

### 1.1 Create Project

1. Go to: **https://console.cloud.google.com/**
2. Click **"Select a project"** → **"New Project"**
3. Project name: `NeoMutt Mail Client`
4. Click **"Create"**

### 1.2 Enable Gmail API

1. In the search bar at top, type: `Gmail API`
2. Click on **"Gmail API"** from results
3. Click **"Enable"** button

### 1.3 Configure OAuth Consent Screen

1. Left sidebar: **"APIs & Services"** → **"OAuth consent screen"**
2. User Type: Select **"External"**
3. Click **"Create"**

**App Information page:**
- App name: `NeoMutt`
- User support email: Your work email
- Developer contact: Your work email
- Click **"Save and Continue"**

**Scopes page:**
- Click **"Add or Remove Scopes"**
- In the filter box, paste: `https://mail.google.com/`
- Check the box for `https://mail.google.com/`
- Click **"Update"**
- Click **"Save and Continue"**

**Test users page:**
- Click **"Add Users"**
- Enter your work email address
- Click **"Add"**
- Click **"Save and Continue"**
- Click **"Back to Dashboard"**

### 1.4 Create OAuth Client Credentials

1. Left sidebar: **"APIs & Services"** → **"Credentials"**
2. Click **"Create Credentials"** → **"OAuth client ID"**
3. Application type: Select **"Desktop app"**
4. Name: `NeoMutt Desktop Client`
5. Click **"Create"**

**IMPORTANT: Copy these now!**
- **Client ID**: `xxxxx.apps.googleusercontent.com`
- **Client secret**: `yyyyy`

Click **"OK"** when done.

---

## Step 2: Update OAuth Script (2 minutes)

Edit the OAuth helper script:
```bash
nvim ~/.config/neomutt/mutt_oauth2.py
```

Find lines 25-26 (near the top):
```python
CLIENT_ID = 'YOUR_CLIENT_ID_HERE.apps.googleusercontent.com'
CLIENT_SECRET = 'YOUR_CLIENT_SECRET_HERE'
```

Replace with your actual values from Step 1.4:
```python
CLIENT_ID = 'xxxxx.apps.googleusercontent.com'  # Your actual Client ID
CLIENT_SECRET = 'yyyyy'  # Your actual Client Secret
```

Save and quit (`:wq`).

---

## Step 3: Authorize NeoMutt (5 minutes)

Run the authorization flow:
```bash
python3 ~/.config/neomutt/mutt_oauth2.py --authorize
```

**What happens:**
1. You'll see output like:
   ```
   ============================================================
   Go to: https://www.google.com/device
   Enter code: ABCD-EFGH
   ============================================================

   Waiting for authorization...
   ```

2. **On your phone or browser:**
   - Go to the URL shown
   - Enter the code shown
   - Sign in with your **work email**
   - **JumpCloud MFA will trigger** (approve it)
   - Grant NeoMutt access to Gmail
   - You'll see "Success!" message

3. **Back in terminal:**
   - You'll see: `✓ Authorization successful! Tokens saved to: ~/.config/neomutt/oauth2_tokens.json`

**Test the script works:**
```bash
python3 ~/.config/neomutt/mutt_oauth2.py
```

You should see a long access token printed (not an error).

---

## Step 4: Create Work Account Config (2 minutes)

Copy the template:
```bash
cp ~/.config/neomutt/accounts/work.secret.template \
   ~/.config/neomutt/accounts/work.secret
```

Edit it:
```bash
nvim ~/.config/neomutt/accounts/work.secret
```

**Replace these 3 places:**
- Line 44: `set from = "your.name@yourcompany.com"` → Your work email
- Line 45: `set realname = "Your Full Name"` → Your name
- Line 48: `set imap_user = "your.name@yourcompany.com"` → Your work email
- Line 61: `set smtp_url = "smtp://your.name@yourcompany.com@smtp.gmail.com:587"` → Your work email

**Everything else stays the same** (the OAuth commands are already configured).

Save and set permissions:
```bash
chmod 600 ~/.config/neomutt/accounts/work.secret
```

---

## Step 5: Test! (1 minute)

Launch NeoMutt:
```bash
neomutt
```

**In NeoMutt:**
- Press `2` to switch to work account
- You should see your work inbox load
- Press `1` to switch back to personal

**Status bar colors:**
- Personal account: **Green** status bar
- Work account: **Cyan** status bar

---

## Troubleshooting

### "Authentication failed"
Check these:
```bash
# 1. Tokens exist?
ls -la ~/.config/neomutt/oauth2_tokens.json

# 2. Script works?
python3 ~/.config/neomutt/mutt_oauth2.py
# Should print an access token, not error

# 3. Work email in test users?
# Go to: https://console.cloud.google.com/
# → OAuth consent screen → Test users
```

### "Token expired" / "Invalid grant"
Re-authorize:
```bash
rm ~/.config/neomutt/oauth2_tokens.json
python3 ~/.config/neomutt/mutt_oauth2.py --authorize
```

### JumpCloud MFA issues
- The OAuth flow **will trigger JumpCloud MFA** (this is normal)
- Approve the MFA prompt on your phone
- Once authorized, tokens auto-refresh (no more MFA needed)
- Tokens last ~1 hour and refresh automatically

### Script errors
Make sure CLIENT_ID and CLIENT_SECRET are set:
```bash
grep -E "(CLIENT_ID|CLIENT_SECRET)" ~/.config/neomutt/mutt_oauth2.py
```

Should show:
```python
CLIENT_ID = 'xxxxx.apps.googleusercontent.com'
CLIENT_SECRET = 'yyyyy'
```

### Gmail API not enabled
Go to: https://console.cloud.google.com/apis/library/gmail.googleapis.com
Click "Enable" if not already enabled.

---

## Quick Reference

| Task | Command |
|------|---------|
| Authorize | `python3 ~/.config/neomutt/mutt_oauth2.py --authorize` |
| Test token | `python3 ~/.config/neomutt/mutt_oauth2.py` |
| Re-authorize | `rm ~/.config/neomutt/oauth2_tokens.json && python3 ~/.config/neomutt/mutt_oauth2.py --authorize` |
| Switch accounts in NeoMutt | Press `1` (personal) or `2` (work) |
| Check tokens | `ls -la ~/.config/neomutt/oauth2_tokens.json` |

---

## Security Notes

- **OAuth2 tokens** live in: `~/.config/neomutt/oauth2_tokens.json` (local only, auto-refresh)
- **Account secrets** live in: `~/.config/neomutt/accounts/*.secret` (local only, gitignored)
- **Templates** are in git (safe, no credentials)
- **CLIENT_ID/SECRET** in `mutt_oauth2.py` could be in git (low risk for personal OAuth app)

To revoke access:
1. Go to: https://myaccount.google.com/permissions
2. Find "NeoMutt" app
3. Click "Remove access"
