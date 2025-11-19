#!/usr/bin/env bash
set -e

echo "Enable hibernation migration running..."

# --- Detect real swap device (partition or file) ---
SWAP_DEVICE=$(findmnt -n -o SOURCE /swapfile 2>/dev/null || true)
if [[ -z "$SWAP_DEVICE" ]]; then
    SWAP_DEVICE=$(swapon --show --raw | awk 'NR==1{print $1}')
fi

if [[ -z "$SWAP_DEVICE" ]]; then
    echo "❌ No swap detected. Cannot enable hibernation."
    echo "Create a swapfile or swap partition first."
    exit 0
fi

echo "✔ Found swap: $SWAP_DEVICE"

# --- Calculate resume offset (only needed for swapfiles) ---
RESUME_DEVICE="$SWAP_DEVICE"
RESUME_OFFSET=""

if [[ "$SWAP_DEVICE" == */swapfile ]]; then
    echo "Calculating swapfile offset..."
    RESUME_OFFSET=$(sudo filefrag -v /swapfile | awk '/physical offset/ {print $4}' | sed 's/\.$//')
    if [[ -z "$RESUME_OFFSET" ]]; then
        echo "❌ Could not compute swapfile resume_offset."
        exit 0
    fi
    echo "✔ resume_offset = $RESUME_OFFSET"
fi

# --- Insert resume arguments into kernel cmdline ---
CMDLINE_CONF="/etc/kernel/cmdline"
if [[ -f "$CMDLINE_CONF" ]]; then
    echo "Updating $CMDLINE_CONF..."

    sudo sed -i "s|resume=[^ ]*||g" "$CMDLINE_CONF"
    sudo sed -i "s|resume_offset=[^ ]*||g" "$CMDLINE_CONF"

    echo -n "resume=$RESUME_DEVICE" | sudo tee -a "$CMDLINE_CONF" >/dev/null

    if [[ -n "$RESUME_OFFSET" ]]; then
        echo -n " resume_offset=$RESUME_OFFSET" | sudo tee -a "$CMDLINE_CONF" >/dev/null
    fi
fi

echo "✔ Kernel cmdline updated"

# --- Rebuild initramfs ---
if command -v dracut &>/dev/null; then
    echo "Rebuilding initramfs using dracut..."
    sudo dracut --regenerate-all --force
elif command -v mkinitcpio &>/dev/null; then
    echo "Rebuilding initramfs using mkinitcpio..."
    sudo mkinitcpio -P
fi

echo "✔ Hibernation migration completed successfully"

