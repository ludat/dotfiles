#!/usr/bin/env bash

set -euo pipefail

set -x

echo -n "0000:04:00.3" | tee /sys/bus/pci/drivers/xhci_hcd/unbind
sleep 2
echo -n "0000:04:00.3" | tee /sys/bus/pci/drivers/xhci_hcd/bind
