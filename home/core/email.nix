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
    # Load account-specific settings from external secrets file
    # This file is NOT tracked in git and should be created manually
    source ~/.config/neomutt/accounts.secret

    # Basic settings
    set editor = "nvim"
    set mail_check = 60
    set timeout = 10

    # Sidebar settings
    set sidebar_visible = yes
    set sidebar_width = 30
    set sidebar_format = "%B%?F? [%F]?%* %?N?%N/?%S"
    set mail_check_stats

    # Key bindings
    bind index,pager \Ck sidebar-prev
    bind index,pager \Cj sidebar-next
    bind index,pager \Co sidebar-open
    bind index,pager \Cp sidebar-prev-new
    bind index,pager \Cn sidebar-next-new
    bind index,pager B sidebar-toggle-visible

    # Colors (will be themed by Stylix)
    color indicator default color8
    color sidebar_highlight default color8
    color sidebar_new green default

    # Viewing HTML emails
    set mailcap_path = ~/.config/neomutt/mailcap
    auto_view text/html
    alternative_order text/plain text/enriched text/html

    # Composing
    set edit_headers = yes
    set fast_reply = yes
    set include = yes
    set forward_quote = yes

    # Index view
    set date_format = "%Y-%m-%d %H:%M"
    set index_format = "%4C %Z %{%b %d} %-20.20L %s"
    set sort = threads
    set sort_aux = reverse-last-date-received
    set uncollapse_jump = yes
    set collapse_unread = yes

    # Pager
    set pager_index_lines = 10
    set pager_context = 3
    set pager_stop = yes
    set menu_scroll = yes
    set tilde = yes
    set markers = no

    # Printing
    set print_command = "lpr"
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
}
