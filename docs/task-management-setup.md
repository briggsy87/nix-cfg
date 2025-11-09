# Task & Project Management Setup

Guide for setting up **JiraTUI** and **Todoist CLI** for terminal-based task management.

**Last Updated:** 2025-11-08

---

## JiraTUI - Jira Terminal Interface

A full-featured TUI for interacting with Atlassian Jira from your terminal.

### Prerequisites

- Access to a Jira instance (Cloud or Data Center)
- Jira account with appropriate permissions

### Initial Setup

#### 1. Generate Jira API Token

For Jira Cloud:

1. Visit: https://id.atlassian.com/manage-profile/security/api-tokens
2. Click **"Create API token"**
3. Give it a name (e.g., "JiraTUI")
4. Copy the token (you only see it once!)
5. Save it securely

For Jira Data Center (on-premise):
- You may use Personal Access Tokens or username/password
- Consult your Jira admin for the authentication method

#### 2. Create Configuration File

After rebuilding your Nix config, a template will be available:

```bash
# Copy template to actual config
cp ~/.config/jiratui/config.yaml.template ~/.config/jiratui/config.yaml

# Edit with your credentials
nvim ~/.config/jiratui/config.yaml
```

#### 3. Fill Required Settings

Edit `~/.config/jiratui/config.yaml`:

```yaml
# ===== REQUIRED SETTINGS =====

# Your Jira email address
jira_api_username: 'your.email@company.com'

# Your Jira API token (from step 1)
jira_api_token: 'your-api-token-here'

# Your Jira instance URL
jira_api_base_url: 'https://yourcompany.atlassian.net'

# Base URL for building web links (same as above)
jira_base_url: 'https://yourcompany.atlassian.net'
```

**Important:** Replace `yourcompany` with your actual Jira domain!

#### 4. Optional: Get Your Jira Account ID

This auto-selects you in dropdowns and is useful for default searches:

```bash
# Visit this URL in your browser (replace yourcompany):
https://yourcompany.atlassian.net/rest/api/3/myself
```

Look for the `accountId` field in the JSON response. Add it to config:

```yaml
jira_account_id: 'your-account-id-here'
```

#### 5. Launch JiraTUI

```bash
jiratui ui
```

### Configuration Highlights

The template includes sensible defaults:

- **50 results per page** - Better than default 30
- **30 day search window** - More comprehensive than default 15
- **Dracula theme** - Matches your terminal aesthetic
- **Smart filtering** - Refine search results easily
- **Fast startup** - Only fetches projects on launch

### Customizing JQL Queries

Add predefined JQL expressions for quick searches:

Edit `~/.config/jiratui/config.yaml`:

```yaml
pre_defined_jql_expressions:
  1:
    name: "My Open Issues"
    expression: "assignee = currentUser() AND status != Done ORDER BY updated DESC"
  2:
    name: "Recent Updates"
    expression: "updated >= -7d ORDER BY updated DESC"
  3:
    name: "In Progress"
    expression: "assignee = currentUser() AND status = 'In Progress' ORDER BY priority DESC"
  4:
    name: "This Sprint"
    expression: "assignee = currentUser() AND sprint in openSprints() ORDER BY rank"

# Set default JQL to use on startup
jql_expression_id_for_work_items_search: 1
```

### Available Themes

Check available themes:

```bash
jiratui themes
```

Change theme in config:

```yaml
theme: 'dracula'  # or monokai, textual-dark, gruvbox, etc.
```

### Usage

```bash
# Launch the TUI
jiratui ui

# List issues from command line
jiratui issues list

# Add a comment
jiratui comments add <issue-key>

# Search users
jiratui users search <query>
```

### Configuration Location

- **Config file:** `~/.config/jiratui/config.yaml`
- **Template:** `~/.config/jiratui/config.yaml.template`
- **Nix source:** `home/shared.nix` (lines 173-248)

### Troubleshooting

**Authentication Errors:**
- Verify API token is correct
- Check Jira URL has no trailing slash
- Ensure `cloud: true` for Jira Cloud, `false` for Data Center

**Can't find projects:**
- Verify you have access to at least one project
- Check `:LspInfo` for any errors (wait, wrong tool - just check terminal output)
- Try accessing `https://yourcompany.atlassian.net/rest/api/3/project` in browser

**SSL Errors:**
- For self-signed certificates, add to config:
```yaml
ssl:
  verify: false  # Only use for internal/dev instances!
```

### Resources

- Official Docs: https://jiratui.readthedocs.io/
- GitHub: https://github.com/whyisdifficult/jiratui

---

## Todoist CLI

Command-line interface for Todoist task management.

**Note:** This is a CLI tool, not a TUI. For a richer interactive experience, consider building a Todoist TUI as a future project!

### Prerequisites

- Todoist account (free or premium)

### Initial Setup

#### 1. Get Todoist API Token

1. Log in to Todoist web: https://todoist.com
2. Go to Settings → Integrations
3. Scroll to **"API token"** section
4. Copy your API token
5. Save it securely

#### 2. Authenticate Todoist CLI

The todoist CLI (from sachaos/todoist) uses a config file:

```bash
# First run will prompt for token
todoist --token YOUR_API_TOKEN list

# Or set environment variable
export TODOIST_TOKEN="your-api-token-here"
```

#### 3. Persist Token

Add to your shell config or create a config file:

**Option 1: Environment Variable (in `~/.zshrc`):**
```bash
export TODOIST_TOKEN="your-api-token-here"
```

**Option 2: Config File:**
```bash
# Create config directory
mkdir -p ~/.config/todoist

# Store token
echo "token: your-api-token-here" > ~/.config/todoist/config.yml
```

**Security Note:** Keep your API token private! Consider using a password manager or sops for secrets.

### Basic Usage

```bash
# List all tasks
todoist list

# Add a new task
todoist add "Write documentation for jiratui"

# Add task with due date
todoist add "Review PR #123" --date tomorrow

# Add task to specific project
todoist add "Deploy to prod" --project Work

# Complete a task
todoist close <task-id>

# Show task details
todoist show <task-id>

# List projects
todoist projects

# List labels
todoist labels

# Filter tasks
todoist list --filter "today | overdue"
```

### Advanced Features

```bash
# Add task with priority (1-4, 4 is highest)
todoist add "Critical bug fix" --priority 4

# Add task with label
todoist add "Read Rust book" --label-ids learning

# Add task with note
todoist add "Meeting prep" --note "Review Q4 metrics"

# Sync with Todoist
todoist sync
```

### Integration Ideas

**Daily Review Script:**
```bash
#!/bin/bash
echo "=== Today's Tasks ==="
todoist list --filter "today"

echo -e "\n=== Overdue ==="
todoist list --filter "overdue"
```

**Quick Add Alias:**
Add to `~/.zshrc`:
```bash
alias t="todoist add"
alias tl="todoist list"
alias td="todoist list --filter today"
```

### Future: Todoist TUI Project

**Potential features for a custom Todoist TUI:**
- Full keyboard navigation (vim-style)
- Kanban board view
- Interactive filtering and search
- Bulk operations
- Offline mode with sync
- Project/label management
- Dracula theme integration

**Tech stack ideas:**
- Rust + ratatui (formerly tui-rs)
- Go + bubbletea
- Python + textual

This could be an excellent open-source project to build!

### Troubleshooting

**Authentication Failed:**
- Verify API token is correct (no extra spaces)
- Check token is still valid at https://todoist.com/app/settings/integrations
- Ensure token has proper permissions

**Command Not Found:**
- Verify `todoist` is in PATH: `which todoist`
- Rebuild Nix config if recently added

**Tasks Not Syncing:**
- Run `todoist sync` manually
- Check network connection
- Verify Todoist API status: https://status.todoist.com/

### Resources

- Todoist API Docs: https://developer.todoist.com/
- sachaos/todoist GitHub: https://github.com/sachaos/todoist

---

## Quick Reference

### JiraTUI
```bash
jiratui ui              # Launch TUI
jiratui issues list     # List issues (CLI)
jiratui config          # Show config location
jiratui themes          # List available themes
```

### Todoist CLI
```bash
todoist list                    # List all tasks
todoist add "task description"  # Quick add
todoist list --filter today     # Today's tasks
todoist close <id>              # Complete task
todoist sync                    # Force sync
```

---

**Configuration Files:**
- JiraTUI: `~/.config/jiratui/config.yaml`
- Todoist: `~/.config/todoist/config.yml` (or use env var)

**Nix Source:**
- Package installation: `home/shared.nix:45-47`
- JiraTUI template: `home/shared.nix:173-248`
