# System-Wide Environment

System-wide environment variables are declared in:
- `/etc/environment` (parsed by pam_env)
- User environment is preferred in `~/.config/environment.d/*.conf` (managed by `environment.sh` module).
