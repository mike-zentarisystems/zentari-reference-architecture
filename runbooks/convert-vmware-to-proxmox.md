# Convert VMware host to Proxmox

This is a destructive change. ADR-0003 must be accepted before execution.

Do not execute until the change record names physical disk/controller identifiers, backup artifact locations and checksums, operator, approver, maintenance window, minimum 72-hour soak period, and explicit abort thresholds for disk, memory, thermal, network, restore, and power tests.

## Preconditions

- Export VM, datastore, virtual network, IP, DNS, dependency, license, and boot-order inventories.
- Confirm each workload owner and whether it is active, migrated, archived, or retired.
- Create two independent backups of every retained workload and restore at least one copy elsewhere.
- Export ESXi configuration and preserve installation media/license details for the rollback window.
- Run memory, CPU, controller, disk SMART/RAID, network, firmware, thermal, and power/UPS checks.
- Confirm Proxmox hardware compatibility, installation target disks, management network, and recovery console.

## Change

1. Stop retained workloads cleanly and take final backups.
2. Verify checksums and boot/restore the final recovery copy.
3. Remove the host from production dependencies and monitoring expectations.
4. Install a pinned supported Proxmox release on the explicitly identified boot disks.
5. Configure storage, private management, updates, time sync, alerts, and backup credentials.
6. Apply the `vault` identity and deny customer production placement.
7. Restore only infrastructure workloads from clean definitions; do not carry forward unknown appliances.

## Validation

Verify console and Tailscale management, storage health, backup throughput, restore VM boot, monitoring, alerting, time sync, reboot behavior, and UPS/power recovery. Hold production workloads off the host through a soak period.

## Rollback

Before disk reformat, abort and restart ESXi. After reformat, reinstall the recorded ESXi version and restore configuration/workloads from verified backups, or keep services on their migration targets. The change owner chooses the lower-risk path based on elapsed time and restore evidence.
