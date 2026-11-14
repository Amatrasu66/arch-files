# Modesty Customization Package & Integration

This directory contains the complete upstream customization package for **Modesty**, the QtQuick/QML Dynamic Island desktop shell powered by QuickShell.

## Upstream Metadata
- **Upstream Repository**: https://github.com/sandeepbist/Modesty.git
- **Base Commit**: `690af8b5905b166997ae0c6c57c44e7ad1f7aef6` (`690af8b`)
- **Upstream License**: GNU General Public License v3.0 (GPL-3.0)

## Package Contents
```
upstream/modesty/
├── README.md               # This documentation
├── upstream.json           # Machine-readable upstream metadata
├── patches/
│   └── modesty-customizations.patch  # Git patch for tracked upstream files
└── additions/              # Complete set of custom authored modules & scripts
    ├── config/shortcuts/
    │   └── shortcut_registry.json
    ├── integrations/compositor/
    │   ├── capabilities.json
    │   ├── CompositorAdapter.qml
    │   └── NiriAdapter.qml
    ├── modules/
    │   ├── island/
    │   │   └── AiAgentPill.qml
    │   └── shortcuts/
    │       └── ShortcutReference.qml
    ├── scripts/
    │   ├── ai-agent-status.py
    │   └── sync_shortcuts.py
    └── services/
        ├── CommandHistory.qml
        ├── CommandProviders.js
        └── Compositor.qml
```

## How It Is Deployed
1. The deployment module (`scripts/modules/modesty.sh`) clones `https://github.com/sandeepbist/Modesty.git` at commit `690af8b`.
2. Applies `patches/modesty-customizations.patch` cleanly.
3. Copies all files from `additions/` into the cloned repository tree.
4. Creates a user symlink: `~/.config/quickshell` -> cloned directory.
5. Enables and starts `quickshell.service`.
