#!/usr/bin/env bash
# Find SPI master created by a given USB device (default: CH341 1a86:5512)

VID="${1:-1a86}"
PID="${2:-5512}"
USB_PORT_HINT="${3:-}" # optional, e.g. "1-6" to pick a specific port

shopt -s nullglob

match_spi=""
for spilink in /sys/class/spi_master/spi*; do
  real=$(readlink -f "$spilink") || continue

  cur="$real"
  while [[ "$cur" != "/" ]]; do
    if [[ -f "$cur/idVendor" && -f "$cur/idProduct" ]]; then
      v=$(tr 'A-Z' 'a-z' < "$cur/idVendor")
      p=$(tr 'A-Z' 'a-z' < "$cur/idProduct")
      if [[ "$v" == "$VID" && "$p" == "$PID" ]]; then
        if [[ -n "$USB_PORT_HINT" ]]; then
          usbdev="$(basename "$cur")"
          if [[ "$usbdev" != "$USB_PORT_HINT" && "$usbdev" != "$USB_PORT_HINT":* ]]; then
            break  # not our hinted port
          fi
        fi
        match_spi="$(basename "$spilink")"
        echo "$match_spi"
        exit 0
      fi
    fi
    cur="$(dirname "$cur")"
  done
done

echo "SPINotFound"
exit 1
