pragma Singleton
import QtQuick
import Quickshell
import "../integrations/compositor"

Singleton {
    id: root

    readonly property bool isHyprland: CompositorAdapter.isHyprland
    readonly property bool isNiri: CompositorAdapter.isNiri

    readonly property var workspaces: CompositorAdapter.workspaces
    readonly property var activeWorkspace: CompositorAdapter.activeWorkspace
    readonly property var activeWindow: CompositorAdapter.activeWindow
    readonly property bool fullscreen: CompositorAdapter.fullscreen

    function monitorFor(screen) {
        return CompositorAdapter.monitorFor(screen);
    }

    function focusWorkspace(idx) {
        CompositorAdapter.focusWorkspace(idx);
    }

    function quit() {
        CompositorAdapter.quit();
    }
}
