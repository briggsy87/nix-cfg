# NeoMutt Email Setup Guide

Complete guide for setting up NeoMutt with multiple Gmail accounts.

## Overview

Your NeoMutt setup supports **two accounts** with easy switching:
- **Personal Gmail**: Using app password (simple, standard Gmail)
- **Work Gmail**: Using OAuth2 (for SSO/MFA with JumpCloud)

## Quick Start (Personal Gmail)

### 1. Get Gmail App Password

1. Go to: https://myaccount.google.com/apppasswords
   - **Note**: You MUST have 2-Factor Authentication enabled first
   - If you don't have 2FA: Go to https://myaccount.google.com/security → Enable 2-Step Verification

2. Sign in with your personal Gmail account

3. Create app password:
   - App: Select "Mail"
   - Device: Select "Other (Custom name)" → Type "NeoMutt"
   - Click "Generate"

4. Copy the 16-character password (remove spaces)
   - Example format: `abcdefghijklmnop`
   - **Save this** - you'll need it in step 3

### 2. Apply Nix Configuration

First, rebuild to get the templates:

```bash
# macOS
darwin-rebuild switch --flake .#m4pro

# Linux
sudo nixos-rebuild switch --flake .#thinkpad
```

### 3. Create Personal Account Config

```bash
# Create accounts directory
mkdir -p ~/.config/neomutt/accounts

# Copy template
cp ~/.config/neomutt/accounts/personal.secret.template \
   ~/.config/neomutt/accounts/personal.secret

# Edit the file
nvim ~/.config/neomutt/accounts/personal.secret
```

Replace these placeholders:
- `your.personal@gmail.com` → Your actual Gmail address (appears 3 times)
- `Your Full Name` → Your actual name
- `YOUR-16-CHAR-APP-PASSWORD-HERE` → The app password from step 1 (appears 2 times)

Save and set permissions:
```bash
chmod 600 ~/.config/neomutt/accounts/personal.secret
```

### 4. Create Placeholder Work Config (For Now)

Since you want to test personal first, create an empty work config:

```bash
touch ~/.config/neomutt/accounts/work.secret
chmod 600 ~/.config/neomutt/accounts/work.secret
```

Or comment out the work account line in the main config for now.

### 5. Launch NeoMutt

```bash
neomutt
```

**Expected behavior:**
- NeoMutt opens to your personal Gmail inbox
- Sidebar shows your mailboxes (Inbox, Sent, Drafts, etc.)
- You can read, compose, and send emails

**Keybindings:**
- `Ctrl-k` / `Ctrl-j` - Navigate sidebar
- `Ctrl-o` - Open selected mailbox
- `1` - Switch to personal account
- `2` - Switch to work account (once configured)
- `c` - Compose new email
- `r` - Reply
- `gg` / `G` - First/last message
- `B` - Toggle sidebar visibility
- `q` - Quit

## Advanced: Work Gmail with OAuth2

Once personal Gmail is working, set up your work account.

### Prerequisites

- Python 3 (already installed via Nix)
- Google account with Gmail API access
- JumpCloud MFA set up

### Step 1: Register OAuth Application

1. Go to: https://console.cloud.google.com/

2. Create project:
   - Click "Select a project" → "New Project"
   - Name: "NeoMutt Mail Client"
   - Click "Create"

3. Enable Gmail API:
   - Search for "Gmail API"
   - Click "Enable"

4. Configure OAuth Consent Screen:
   - Go to "APIs & Services" → "OAuth consent screen"
   - User Type: "External"
   - App name: "NeoMutt"
   - User support email: Your work email
   - Developer contact: Your work email
   - Save and Continue

   On Scopes page:
   - Add scope: `https://mail.google.com/`
   - Save and Continue

   On Test users page:
   - Add your work email address
   - Save and Continue

5. Create OAuth Client:
   - "APIs & Services" → "Credentials"
   - "Create Credentials" → "OAuth client ID"
   - Type: "Desktop app"
   - Name: "NeoMutt Desktop"
   - Click "Create"
   - **SAVE the Client ID and Client Secret**

### Step 2: Configure OAuth Script

Edit the OAuth helper:
```bash
nvim ~/.config/neomutt/mutt_oauth2.py
```

Find lines ~25-26 and replace:
```python
CLIENT_ID = 'your-actual-client-id-here.apps.googleusercontent.com'
CLIENT_SECRET = 'your-actual-client-secret-here'
```

### Step 3: Authorize

Run the authorization flow:
```bash
python3 ~/.config/neomutt/mutt_oauth2.py --authorize
```

This will:
1. Show you a URL (like https://www.google.com/device)
2. Show you a code to enter
3. You visit the URL, enter the code
4. Sign in with work email (JumpCloud MFA will trigger)
5. Grant access to Gmail
6. Tokens saved to `~/.config/neomutt/oauth2_tokens.json`

### Step 4: Create Work Account Config

```bash
# Copy template
cp ~/.config/neomutt/accounts/work.secret.template \
   ~/.config/neomutt/accounts/work.secret

# Edit
nvim ~/.config/neomutt/accounts/work.secret
```

Replace:
- `your.name@yourcompany.com` → Your work email (appears 3 times)
- `Your Full Name` → Your name

Set permissions:
```bash
chmod 600 ~/.config/neomutt/accounts/work.secret
```

### Step 5: Test

Launch NeoMutt:
```bash
neomutt
```

Press `2` to switch to work account.

## Credential Storage

### Current Approach: Local Files

Your account configs live in:
```
~/.config/neomutt/accounts/
├── personal.secret  (gitignored, not in repo)
├── work.secret      (gitignored, not in repo)
├── personal.secret.template  (from Nix, safe to share)
└── work.secret.template      (from Nix, safe to share)
```

**Pros:**
- Simple and straightforward
- Easy to test and debug
- Can store credentials in Bitwarden

**To set up on a new machine:**
1. Apply Nix config (templates auto-created)
2. Retrieve credentials from Bitwarden
3. Create `.secret` files manually
4. Done!

### Alternative: SOPS Encryption (Optional)

If you want credentials in git (encrypted), we can set up SOPS later.

**Pros:**
- Credentials in git (encrypted with age/GPG)
- Portable across machines (just need your private key)

**Cons:**
- More complex setup
- Key management required

Let me know if you want to explore this option after testing.

## Troubleshooting

### Personal Gmail Issues

**"Login failed"**
- Verify 2FA is enabled on your Google account
- Check app password is correct (16 chars, no spaces)
- Try regenerating app password

**"Connection refused"**
- Check internet connection
- Gmail IMAP might be disabled: https://mail.google.com/mail/u/0/#settings/fwdandpop

### Work Gmail (OAuth2) Issues

**"Authentication failed"**
- Run authorization: `python3 ~/.config/neomutt/mutt_oauth2.py --authorize`
- Check tokens exist: `ls -la ~/.config/neomutt/oauth2_tokens.json`
- Verify work email is in OAuth consent screen test users

**"Token expired"**
Tokens auto-refresh, but if issues persist:
```bash
rm ~/.config/neomutt/oauth2_tokens.json
python3 ~/.config/neomutt/mutt_oauth2.py --authorize
```

**JumpCloud issues**
- OAuth flow WILL trigger MFA (expected)
- Complete the MFA challenge
- Tokens last ~1 hour and auto-refresh
- You won't need MFA again unless tokens are revoked

### General Issues

**Mailbox not found**
- Gmail uses `[Gmail]/Sent Mail` not `Sent`
- Check folder names match exactly

**Slow performance**
- Cache directories speed things up (already configured)
- Consider using `mbsync` for offline mail (future enhancement)

## File Locations

| File | Purpose | In Git? |
|------|---------|---------|
| `home/core/email.nix` | NeoMutt Nix config | Yes |
| `home/core/mutt_oauth2.py` | OAuth2 helper script | Yes (template) |
| `home/core/personal.secret.template` | Personal account template | Yes |
| `home/core/work.secret.template` | Work account template | Yes |
| `~/.config/neomutt/neomuttrc` | Main config (generated by Nix) | No (generated) |
| `~/.config/neomutt/accounts/personal.secret` | Personal credentials | **No (gitignored)** |
| `~/.config/neomutt/accounts/work.secret` | Work credentials | **No (gitignored)** |
| `~/.config/neomutt/oauth2_tokens.json` | OAuth2 tokens | **No (auto-generated)** |
| `~/.cache/neomutt/` | Cache directory | No (ephemeral) |

## Next Steps

1. **Test personal Gmail** - Make sure basic setup works
2. **Configure work Gmail** - Once comfortable with NeoMutt
3. **Optional enhancements:**
   - Set up `mbsync` (isync) for offline mail
   - Configure SOPS for encrypted credentials in git
   - Add more accounts if needed
   - Customize keybindings
   - Theme colors to match your terminal

## Additional Resources

- [NeoMutt Documentation](https://neomutt.org/guide/)
- [Gmail IMAP Settings](https://support.google.com/mail/answer/7126229)
- [Google OAuth2 for Devices](https://developers.google.com/identity/protocols/oauth2/limited-input-device)
- [mbsync Tutorial](https://wiki.archlinux.org/title/Isync)
