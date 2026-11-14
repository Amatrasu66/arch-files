# Audio Configuration (PipeWire & WirePlumber)

Audio is managed by PipeWire 1.6.10:
- Session manager: `wireplumber`
- PulseAudio emulation: `pipewire-pulse`
- ALSA bridge: `pipewire-alsa`
- Active sinks: Bluetooth (CMF Buds via bluez5), Built-in HDMI Audio.
- Inspection: `wpctl status`, `wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+`.
