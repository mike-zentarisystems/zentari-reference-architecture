# Break-glass access

Use only when ordinary identity or private-network access is unavailable.

1. Open an incident record and name two people when available: operator and witness.
2. Retrieve the sealed credential through the documented custody mechanism.
3. Access only the minimum provider or system needed to restore normal IAM/Tailscale access.
4. Record commands/actions without recording credential values.
5. Restore normal access, revoke active sessions, rotate the break-glass credential, reseal recovery material, and review audit logs.
6. Close only after confirming no persistent privilege or public exposure remains.

The credential locations and values are deliberately not stored in this repository.
