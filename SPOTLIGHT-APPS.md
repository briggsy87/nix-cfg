# Spotlight Integration for Nix Apps

## How It Works

The activation script in `hosts/m4pro.nix` automatically creates symlinks in `~/Applications/Nix Apps/` for all `.app` bundles installed by Nix. Spotlight indexes this directory so apps become searchable.

## Important Notes

**CLI tools (nvim, ripgrep, etc.) will NOT appear in Spotlight** because they aren't macOS application bundles (.app). They're still available in your terminal!

**Only GUI apps packaged as .app bundles** will show up in Spotlight. Examples:
- Alacritty (if installed)
- Aerospace (window manager)
- Any GUI apps from Homebrew casks

## Troubleshooting

### Apps Not Showing in Spotlight?

1. **Check the directory was created:**
   ```bash
   ls -la ~/Applications/Nix\ Apps/
   ```
   You should see symlinks to .app bundles.

2. **Manually trigger Spotlight reindex:**
   ```bash
   mdimport ~/Applications/Nix\ Apps/
   ```

3. **Check Spotlight privacy settings:**
   - Open System Settings → Siri & Spotlight → Spotlight Privacy
   - Make sure `~/Applications/Nix Apps` is NOT in the exclusion list
   - If it is, remove it

4. **Force full Spotlight rebuild (if needed):**
   ```bash
   sudo mdutil -E /
   ```
   This rebuilds the entire Spotlight index (takes a few minutes).

5. **Check what apps are actually installed:**
   ```bash
   ls -la /Applications/*.app
   ```

## Where Are My Nix Apps?

- **System-level apps:** `/Applications/*.app`
- **User-level apps:** `~/Applications/Nix Apps/*.app` (symlinks to /Applications)
- **Nix store binaries:** `/nix/store/*/Applications/*.app`

## Can't Find an App?

Some Nix packages don't create .app bundles. If you need a specific GUI app:

1. **Check if it's packaged for darwin:**
   ```bash
   nix search nixpkgs <app-name>
   ```

2. **Install via Homebrew cask** (add to `hosts/m4pro.nix`):
   ```nix
   homebrew.casks = [
     "app-name"
   ];
   ```

3. **Download directly** from the app's website
