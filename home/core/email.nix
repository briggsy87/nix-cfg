{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    neomutt
    isync # mbsync for syncing mail
    msmtp # For sending mail
    pass  # Password manager (recommended for storing app passwords)
    w3m
    python3 # For OAuth2 helper script
    cyrus_sasl # SASL authentication support
  ];

  # Neomutt configuration
  xdg.configFile."neomutt/neomuttrc" = {
    force = true;
    text = ''
    # Multi-account setup
    # Account-specific settings loaded from external secrets file
    # This file is NOT tracked in git and should be created manually
    # See: ~/.config/neomutt/accounts.secret.template for setup instructions

    # Source personal account (default)
    source ~/.config/neomutt/accounts/personal.secret

    # Source work account
    source ~/.config/neomutt/accounts/work.secret

    # Set personal as default account
    folder-hook $folder 'source ~/.config/neomutt/accounts/personal.secret'

    # Account switching macros
    # Press '1' for personal, '2' for work in index/pager view
    macro index,pager 1 '<sync-mailbox><enter-command>source ~/.config/neomutt/accounts/personal.secret<enter><change-folder>!<enter>'
    macro index,pager 2 '<sync-mailbox><enter-command>source ~/.config/neomutt/accounts/work.secret<enter><change-folder>!<enter>'

    # Basic settings
    set editor = "nvim"
    set mail_check = 60
    set timeout = 10
    set imap_keepalive = 300
    set imap_check_subscribed = yes

    # Sidebar settings
    set sidebar_visible = yes
    set sidebar_width = 30
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats
    set sidebar_short_path = yes
    set sidebar_folder_indent = yes
    set sidebar_indent_string = "  "

    # Key bindings
    bind index,pager \Ck sidebar-prev
    bind index,pager \Cj sidebar-next
    bind index,pager \Co sidebar-open
    bind index,pager \Cp sidebar-prev-new
    bind index,pager \Cn sidebar-next-new
    bind index,pager B sidebar-toggle-visible

    # Vim-like navigation
    bind index,pager g noop
    bind index gg first-entry
    bind index G last-entry
    bind pager gg top
    bind pager G bottom
    bind pager j next-line
    bind pager k previous-line

    # Dracula Theme for NeoMutt
    # Based on: https://draculatheme.com/neomutt
    # Background: #282a36, Foreground: #f8f8f2
    # Current Line: #44475a, Selection: #44475a
    # Comment: #6272a4, Cyan: #8be9fd, Green: #50fa7b
    # Orange: #ffb86c, Pink: #ff79c6, Purple: #bd93f9
    # Red: #ff5555, Yellow: #f1fa8c

    # General colors
    color normal      color255 color0    # Default text (fg: #f8f8f2, bg: #282a36)
    color error       color203 color0    # Error messages (red)
    color tilde       color61  color0    # ~ lines after message
    color message     color141 color0    # Info messages (purple)
    color markers     color203 color0    # + wrapped lines marker
    color attachment  color212 color0    # Attachments (pink)
    color search      color84  color0    # Search highlight (green)
    color status      color0   color141  # Status bar (inverted purple)
    color indicator   color0   color141  # Current selected message (inverted purple)
    color tree        color117 color0    # Thread tree arrows (cyan)

    # Sidebar colors
    color sidebar_new       color84  color0    # New mail indicator (green)
    color sidebar_highlight color0   color61   # Selected mailbox (purple bg)
    color sidebar_indicator color0   color141  # Indicator (purple)
    color sidebar_divider   color61  color0    # Divider (comment)

    # Index colors (message list)
    color index color255 color0  "~A"           # All messages (default)
    color index color84  color0  "~N"           # New messages (green)
    color index color84  color0  "~O"           # Old unread messages (green)
    color index color212 color0  "~F"           # Flagged messages (pink)
    color index color203 color0  "~D"           # Deleted messages (red)
    color index color61  color0  "~T"           # Tagged messages (comment)
    color index color228 color0  "~Q"           # Messages replied to (yellow)

    # Header colors
    color hdrdefault color61  color0            # Default headers (comment)
    color header     color141 color0  "^(From|Subject):"  # Important headers (purple)
    color header     color117 color0  "^(To|Cc|Bcc):"     # Recipient headers (cyan)
    color header     color84  color0  "^Date:"            # Date header (green)

    # Body colors
    color quoted  color84  color0    # Quoted text level 1 (green)
    color quoted1 color117 color0    # Quoted text level 2 (cyan)
    color quoted2 color141 color0    # Quoted text level 3 (purple)
    color quoted3 color228 color0    # Quoted text level 4 (yellow)
    color quoted4 color212 color0    # Quoted text level 5 (pink)
    color quoted5 color203 color0    # Quoted text level 6 (red)

    # URL highlighting (simplified, reliable regex)
    color body color117 color0 "(https?|ftp)://[^ \t\r\n<>\"]*[^].,:;!)? \t\r\n<>\"]"
    color body color117 color0 "www\\.[^ \t\r\n<>\"]*[^].,:;!)? \t\r\n<>\"]"

    # Email addresses
    color body color212 color0 "[-a-z_0-9.%$]+@[-a-z_0-9.]+\\.[-a-z][-a-z]+"

    # Emoji and special characters
    color body color228 color0 "[;:][-o][)/(|]"    # Emoticons
    color body color228 color0 "[;:][)(|]"

    # Bold and underline
    color bold      color228 color0
    color underline color117 color0

    # Viewing HTML emails
    set mailcap_path = ~/.config/neomutt/mailcap
    auto_view text/html
    alternative_order text/plain text/enriched text/html

    # Composing
    set edit_headers = yes
    set fast_reply = yes
    set include = yes
    set forward_quote = yes
    set reply_to = yes
    set reverse_name = yes  # Reply with the address used in To/Cc

    # Index view
    set date_format = "%Y-%m-%d %H:%M"
    set index_format = "%4C %Z %{%b %d} %-20.20L %s"
    set sort = threads
    set sort_aux = reverse-last-date-received
    set uncollapse_jump = yes
    set collapse_unread = yes
    set mark_old = no  # Don't mark unread mail as old

    # Pager
    set pager_index_lines = 10
    set pager_context = 3
    set pager_stop = yes
    set menu_scroll = yes
    set tilde = yes
    set markers = no

    # Status bar formatting
    set status_format = "-%r-NeoMutt: %f [Msgs:%?M?%M/?%m%?n? New:%n?%?o? Old:%o?%?d? Del:%d?%?F? Flag:%F?%?t? Tag:%t?%?p? Post:%p?%?b? Inc:%b?%?l? %l?]---(%s/%S)-%>-(%P)---"

    # Printing
    set print_command = "lpr"

    # Performance tweaks
    set sleep_time = 0  # Don't pause on info messages
  '';
  };

  # Mailcap for viewing HTML emails
  xdg.configFile."neomutt/mailcap" = {
    force = true;
    text = ''
    text/html; w3m -I %{charset} -T text/html; copiousoutput;
    text/html; lynx -assume_charset=%{charset} -display_charset=utf-8 -dump -width=1024 %s; nametemplate=%s.html; copiousoutput
  '';
  };

  # OAuth2 helper script for Gmail
  xdg.configFile."neomutt/mutt_oauth2.py" = {
    source = ./mutt_oauth2.py;
    executable = true;
    force = true;
  };

  # Account configuration templates
  # Copy these to create your actual account configs (see instructions in templates)
  xdg.configFile."neomutt/accounts/personal.secret.template" = {
    source = ./personal.secret.template;
    force = true;
  };

  xdg.configFile."neomutt/accounts/work.secret.template" = {
    source = ./work.secret.template;
    force = true;
  };
}
