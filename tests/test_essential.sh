#!/usr/bin/env bash
set -euo pipefail

# Create temporary directory for stubs and logs
TMPDIR=$(mktemp -d)
STUB_DIR="$TMPDIR/stubs"
mkdir -p "$STUB_DIR"
APT_LOG="$TMPDIR/apt.log"
touch "$APT_LOG"

# Create apt stub that logs calls
cat > "$STUB_DIR/apt" <<'EOS'
#!/usr/bin/env bash
echo "$@" >> "$APT_STUB_LOG"
exit 0
EOS
chmod +x "$STUB_DIR/apt"

# Export variables for stub
# keep original PATH for helper utilities
ORIG_PATH="$PATH"
export APT_STUB_LOG="$APT_LOG"

# Override `command -v` to pretend essentials are missing
command() {
    if [[ "$1" == "-v" && ( "$2" == "curl" || "$2" == "wget" || "$2" == "unzip" || "$2" == "lsb-release" ) ]]; then
        return 1
    fi
    builtin command "$@"
}
export -f command

# Determine repository root (parent of this script)
SCRIPT_DIR="${0%/*}/.."
SCRIPT_DIR="$(cd "$SCRIPT_DIR" && pwd)"
cd "$SCRIPT_DIR"

# Run essential.sh with PATH pointing to stubs first
PATH="$STUB_DIR:$ORIG_PATH" /bin/bash ./essential.sh > "$TMPDIR/out.log" 2>&1

# Verify that each essential package was attempted to install
for pkg in curl wget unzip lsb-release; do
    if ! grep -q "$pkg" "$APT_LOG"; then
        echo "Package $pkg not handled" >&2
        cat "$TMPDIR/out.log" >&2
        exit 1
    fi
done

echo "All essential packages handled"

