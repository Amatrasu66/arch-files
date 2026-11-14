pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property bool isNiri: true
    property var rawWorkspaces: []
    property var rawWindows: []
    property var workspaces: []
    property var activeWorkspace: null
    property int activeWorkspaceId: 1
    property string activeWorkspaceName: "1"

    property var activeWindow: null
    property bool fullscreen: false
    property var monitors: []

    function updateWorkspaces(list) {
        if (!Array.isArray(list)) return;
        rawWorkspaces = list;
        const result = [];
        let focusedWs = null;
        for (let i = 0; i < list.length; i++) {
            const w = list[i];
            const wsObj = {
                id: w.id,
                idx: w.idx,
                name: w.name ? String(w.name) : String(w.idx),
                output: w.output || "HDMI-A-1",
                urgent: !!w.is_urgent,
                active: !!w.is_active,
                isFocused: !!w.is_focused,
                monitor: { name: w.output || "HDMI-A-1" },
                activate: function() {
                    Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(w.idx)]);
                }
            };
            result.push(wsObj);
            if (w.is_focused || w.is_active) {
                focusedWs = wsObj;
            }
        }
        workspaces = result;
        if (focusedWs) {
            activeWorkspace = focusedWs;
            activeWorkspaceId = focusedWs.id;
            activeWorkspaceName = focusedWs.name;
        }
    }

    function updateWindows(list) {
        if (!Array.isArray(list)) return;
        rawWindows = list;
        let focusedWin = null;
        let isFs = false;
        for (let i = 0; i < list.length; i++) {
            const win = list[i];
            if (win.is_focused) {
                focusedWin = {
                    id: win.id,
                    title: win.title || "",
                    appId: win.app_id || "",
                    pid: win.pid,
                    workspaceId: win.workspace_id,
                    focused: true,
                    floating: !!win.is_floating,
                    urgent: !!win.is_urgent,
                    fullscreen: !!(win.layout && win.layout.is_fullscreen)
                };
                if (focusedWin.fullscreen) isFs = true;
            }
        }
        activeWindow = focusedWin;
        fullscreen = isFs;
    }

    function focusWorkspace(idx) {
        Quickshell.execDetached(["niri", "msg", "action", "focus-workspace", String(idx)]);
    }

    function closeWindow() {
        Quickshell.execDetached(["niri", "msg", "action", "close-window"]);
    }

    function quit() {
        Quickshell.execDetached(["niri", "msg", "action", "quit", "--skip-confirmation"]);
    }

    function powerOffMonitors() {
        Quickshell.execDetached(["niri", "msg", "action", "power-off-monitors"]);
    }

    function powerOnMonitors() {
        Quickshell.execDetached(["niri", "msg", "action", "power-on-monitors"]);
    }

    function screenshot() {
        Quickshell.execDetached(["niri", "msg", "action", "screenshot-screen"]);
    }

    Process {
        id: eventStream
        command: ["niri", "msg", "-j", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                try {
                    const ev = JSON.parse(line);
                    if (ev.WorkspacesChanged) {
                        root.updateWorkspaces(ev.WorkspacesChanged.workspaces);
                    } else if (ev.WindowsChanged) {
                        root.updateWindows(ev.WindowsChanged.windows);
                    } else if (ev.WorkspaceActivated) {
                        root.activeWorkspaceId = ev.WorkspaceActivated.id;
                        for (let i = 0; i < root.workspaces.length; i++) {
                            if (root.workspaces[i].id === ev.WorkspaceActivated.id) {
                                root.activeWorkspace = root.workspaces[i];
                                root.activeWorkspaceName = root.workspaces[i].name;
                                break;
                            }
                        }
                    } else if (ev.WindowFocusChanged) {
                        const winId = ev.WindowFocusChanged.id;
                        if (root.rawWindows) {
                            for (let i = 0; i < root.rawWindows.length; i++) {
                                if (root.rawWindows[i].id === winId) {
                                    root.activeWindow = {
                                        id: root.rawWindows[i].id,
                                        title: root.rawWindows[i].title || "",
                                        appId: root.rawWindows[i].app_id || "",
                                        pid: root.rawWindows[i].pid,
                                        workspaceId: root.rawWindows[i].workspace_id,
                                        focused: true
                                    };
                                    break;
                                }
                            }
                        }
                    }
                } catch (e) {}
            }
        }
        onExited: exitCode => {
            restartTimer.start();
        }
    }

    Timer {
        id: restartTimer
        interval: 1000
        repeat: false
        onTriggered: {
            if (!eventStream.running) eventStream.running = true;
        }
    }
}
