# Secrets Management

This repository is designed to be publicly shared on GitHub. Sensitive information should **never** be committed directly to this repository.

## Current Status

✅ **Safe to share publicly** - No secrets currently in repository

## For Future Secrets (SMB shares, API keys, etc.)

When you need to add secrets, use **sops-nix**:

### Setup sops-nix

1. **Add sops-nix to flake inputs:**
   ```nix
   # In flake.nix inputs:
   sops-nix.url = "github:Mic92/sops-nix";
   sops-nix.inputs.nixpkgs.follows = "nixpkgs";
   ```

2. **Import sops-nix module:**
   ```nix
   # In your host configuration modules:
   imports = [ sops-nix.nixosModules.sops ];
   # or for darwin:
   imports = [ sops-nix.darwinModules.sops ];
   ```

3. **Create encrypted secrets:**
   ```bash
   # Generate age key
   nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"

   # Create .sops.yaml in repo root
   cat > .sops.yaml <<EOF
   keys:
     - &user YOUR_AGE_PUBLIC_KEY_HERE
   creation_rules:
     - path_regex: secrets/.*\.yaml$
       key_groups:
       - age:
         - *user
   EOF

   # Create secrets directory (already gitignored)
   mkdir -p secrets

   # Edit secrets (will be encrypted automatically)
   nix-shell -p sops --run "sops secrets/secrets.yaml"
   ```

4. **Use secrets in configuration:**
   ```nix
   # Example: SMB mount
   sops.secrets.smb-credentials = {
     sopsFile = ./secrets/secrets.yaml;
     path = "/run/secrets/smb-credentials";
   };

   fileSystems."/mnt/share" = {
     device = "//server/share";
     fsType = "cifs";
     options = [ "credentials=/run/secrets/smb-credentials" ];
   };
   ```

## What to Keep Secret

- 🔒 Passwords and passphrases
- 🔒 API keys and tokens
- 🔒 SSH private keys
- 🔒 Certificate private keys
- 🔒 SMB/NFS credentials
- 🔒 Personal email addresses (if privacy is a concern)
- 🔒 Internal network details (IPs, hostnames)

## What's Safe to Share

- ✅ Usernames (kyle.briggs, briggsy)
- ✅ Timezone settings
- ✅ Package lists
- ✅ Configuration file structures
- ✅ System preferences (dock, finder, etc.)
- ✅ Public dotfiles (neovim, zsh, etc.)

## Before Each Commit

Run this checklist:
```bash
# Search for potential secrets
grep -rE "(password|secret|key|token|api)" . --include="*.nix"

# Check git status for unexpected files
git status

# Review changes before committing
git diff
```

## Resources

- [sops-nix Documentation](https://github.com/Mic92/sops-nix)
- [SOPS Documentation](https://github.com/mozilla/sops)
- [Age Encryption](https://github.com/FiloSottile/age)
