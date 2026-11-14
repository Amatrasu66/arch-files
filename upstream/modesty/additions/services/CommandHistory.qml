pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    property var history: []
    property bool loaded: false

    function record(item): void {
        if (!item || !item.key) return;
        // Never log sensitive arguments or passwords
        const clean = {
            key: String(item.key),
            kind: String(item.kind || "action"),
            title: String(item.title || ""),
            subtitle: String(item.subtitle || ""),
            category: String(item.category || "Action"),
            icon: String(item.icon || "bolt"),
            shortcut: String(item.shortcut || ""),
            appId: String(item.appId || ""),
            actionId: String(item.actionId || ""),
            niriAction: String(item.niriAction || ""),
            lastUsed: Date.now(),
            count: 1
        };

        const existingIdx = history.findIndex(h => h.key === clean.key);
        let list = history.slice();
        if (existingIdx >= 0) {
            clean.count = (list[existingIdx].count || 1) + 1;
            list.splice(existingIdx, 1);
        }
        list.unshift(clean);
        if (list.length > 50) list = list.slice(0, 50);
        history = list;
        save();
    }

    function getRecent(limit): var {
        const maxItems = limit || 6;
        return history.slice(0, maxItems);
    }

    function clear(): void {
        history = [];
        save();
    }

    function save(): void {
        try {
            historyFile.setText(JSON.stringify(history, null, 2));
        } catch (e) {
            console.warn("Could not save command history:", e);
        }
    }

    FileView {
        id: historyFile
        path: Preferences.preview ? "" : Preferences.stateDir + "/command_history.json"
        printErrors: false
        onLoaded: {
            try {
                const parsed = JSON.parse(text());
                if (Array.isArray(parsed)) {
                    root.history = parsed;
                } else {
                    root.history = [];
                }
            } catch (e) {
                root.history = [];
            }
            root.loaded = true;
        }
    }
}
