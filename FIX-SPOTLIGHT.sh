#!/usr/bin/env bash
#
# Fix Spotlight indexing for Nix-installed GUI apps
#
# Home Manager creates ~/Applications/Home Manager Apps/ but Spotlight
# doesn't always index symlinks into the Nix store properly.
#
# This script forces Spotlight to see the apps.

set -e

echo "====================================================================="
echo "Fixing Spotlight indexing for Nix apps"
echo "====================================================================="

HM_APPS="$HOME/Applications/Home Manager Apps"

if [ ! -d "$HM_APPS" ]; then
    echo "❌ Error: $HM_APPS doesn't exist yet"
    echo "   Run 'darwin-rebuild switch' first to create it"
    exit 1
fi

echo ""
echo "Step 1: Checking what apps are installed..."
echo "---------------------------------------------------------------------"
ls -1 "$HM_APPS" | grep ".app$" || echo "No apps found!"

echo ""
echo "Step 2: Forcing Spotlight to reindex..."
echo "---------------------------------------------------------------------"
mdimport "$HM_APPS"

echo ""
echo "Step 3: Checking Spotlight Privacy settings..."
echo "---------------------------------------------------------------------"
# Check if the directory is excluded from Spotlight
if mdfind -onlyin "$HM_APPS" kMDItemKind == "Application" 2>/dev/null | wc -l | grep -q "^0$"; then
    echo "⚠️  Warning: Directory might be excluded from Spotlight indexing"
    echo ""
    echo "To fix:"
    echo "1. Open System Settings → Siri & Spotlight → Spotlight Privacy"
    echo "2. Make sure '$HM_APPS' is NOT in the list"
    echo "3. If it is, select it and click the '-' button to remove it"
    echo ""
else
    echo "✓ Directory is being indexed"
fi

echo ""
echo "Step 4: Testing Spotlight search..."
echo "---------------------------------------------------------------------"
sleep 2  # Give Spotlight a moment to update

FOUND=$(mdfind -onlyin "$HM_APPS" kMDItemKind == "Application" 2>/dev/null | wc -l | tr -d ' ')
echo "Spotlight found $FOUND app(s)"

if [ "$FOUND" -eq "0" ]; then
    echo ""
    echo "⚠️  Apps still not showing up. Try these solutions:"
    echo ""
    echo "Option 1: Full Spotlight rebuild (takes a few minutes)"
    echo "  sudo mdutil -E /"
    echo ""
    echo "Option 2: Check System Settings → Siri & Spotlight → Spotlight Privacy"
    echo "  Ensure ~/Applications is not excluded"
    echo ""
    echo "Option 3: Just use Alfred or Raycast instead"
    echo "  They handle Nix apps better than Spotlight"
    echo ""
else
    echo "✓ Success! Apps should now appear in Spotlight"
    echo ""
    echo "Test it: Press Cmd+Space and type 'aerospace' or 'alacritty'"
fi

echo ""
echo "====================================================================="
