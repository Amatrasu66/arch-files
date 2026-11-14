pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root

    readonly property bool isHyprland: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") !== ""
    readonly property bool isNiri: !isHyprland

    readonly property var workspaces: isNiri ? NiriAdapter.workspaces : Hyprland.workspaces.values
    readonly property var activeWorkspace: isNiri ? NiriAdapter.activeWorkspace : Hyprland.focusedWorkspace
    readonly property var activeWindow: isNiri ? NiriAdapter.activeWindow : Hyprland.activeToplevel
    readonly property bool fullscreen: isNiri ? NiriAdapter.fullscreen : false

    function monitorFor(screen) {
        if (isNiri) {
            return {
                name: screen?.name ?? "HDMI-A-1",
                activeWorkspace: NiriAdapter.activeWorkspace
            };
        }
        return Hyprland.monitorFor(screen);
    }

    function focusWorkspace(idx) {
        if (isNiri) {
            NiriAdapter.focusWorkspace(idx);
        } else {
            Quickshell.execDetached(["hyprctl", "dispatch", "workspace", String(idx)]);
        }
    }

    function quit() {
        if (isNiri) {
            NiriAdapter.quit();
        } else {
            Quickshell.execDetached(["hyprctl", "dispatch", "exit"]);
        }
    }
}
