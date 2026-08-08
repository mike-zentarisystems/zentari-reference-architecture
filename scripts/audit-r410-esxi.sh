#!/bin/sh

# Read-only ESXi audit for the Dell R410 before conversion to Proxmox.
# Run from the ESXi shell/SSH session. Commands that do not exist on a
# particular ESXi build are allowed to fail so the rest of the audit continues.

HOST="$(hostname 2>/dev/null || echo r410)"
STAMP="$(date +%Y%m%d-%H%M%S 2>/dev/null || date +%Y%m%d)"
OUT="r410-esxi-audit-${HOST}-${STAMP}.txt"

{
  echo "Zentari R410 ESXi Pre-Wipe Audit"
  echo "Host: $HOST"
  echo "Time: $(date)"
  echo

  echo "== ESXi version =="
  vmware -vl 2>&1 || true
  echo

  echo "== CPU =="
  esxcli hardware cpu global get 2>&1 || true
  echo

  echo "== Memory =="
  esxcli hardware memory get 2>&1 || true
  echo

  echo "== PCI devices =="
  esxcli hardware pci list 2>&1 || true
  echo

  echo "== Storage devices =="
  esxcli storage core device list 2>&1 || true
  echo

  echo "== Storage paths =="
  esxcli storage core path list 2>&1 || true
  echo

  echo "== VMFS extents =="
  esxcli storage vmfs extent list 2>&1 || true
  echo

  echo "== Filesystems =="
  esxcli storage filesystem list 2>&1 || true
  echo

  echo "== Network interfaces =="
  esxcli network nic list 2>&1 || true
  echo

  echo "== Registered VMs =="
  vim-cmd vmsvc/getallvms 2>&1 || true
  echo

  echo "== Datastore summary =="
  esxcli storage filesystem list 2>&1 || true
  echo

  echo "NOTE: ESXi output may not expose physical RAID member health."
  echo "Capture iDRAC/PERC screenshots showing controller, virtual disks, RAID level,"
  echo "physical disks, predictive-failure state, and battery/cache health before wipe."
} > "$OUT" 2>&1

cat "$OUT"
echo
echo "Evidence file: $OUT"
