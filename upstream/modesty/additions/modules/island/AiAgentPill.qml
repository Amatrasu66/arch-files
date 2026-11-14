import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import qs.components
import qs.services
import qs.theme

Item {
    id: root

    readonly property bool active: AgentWork.active || (AgentWork.pulse && AgentWork.kind !== "working")
    readonly property bool expanded: IslandState.menu === "agent"
    readonly property string appName: AgentWork.providerLabel || "Agent"
    readonly property string taskTitle: AgentWork.currentTask || ""
    readonly property int agentCount: AgentWork.agentCount || 1
    readonly property string kind: AgentWork.kind || "working"
    readonly property string statusLabel: AgentWork.statusText || "Working"
    readonly property string iconName: AgentWork.appIcon || "antigravity"
    readonly property real capsuleRadius: Preferences.barHeight / 2

    // Size and visibility
    implicitHeight: Preferences.barHeight
    readonly property real targetWidth: active ? (agentCount > 1 ? 275 : 225) : 0
    width: targetWidth
    Behavior on width {
        NumberAnimation { duration: Tokens.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic }
    }

    visible: (active || expanded) && opacity > 0.01
    opacity: active || expanded ? 1.0 : 0.0
    Behavior on opacity {
        NumberAnimation { duration: Tokens.animFast; easing.type: Easing.InOutCubic }
    }

    // Wayland layer-shell input region
    readonly property Item inputRegion: Item {
        parent: root
        x: -4
        y: 0
        width: root.width > 0 ? root.width + 8 : 0
        height: root.expanded && cardsContainer.visible ? (cardsContainer.y + cardsContainer.height + 12) : (Preferences.barHeight + 7)
    }

    function toggleExpand(): void {
        if (expanded) {
            IslandState.closeMenu();
        } else {
            IslandState.openMenu("agent");
        }
    }

    function formatTime(ms): string {
        if (!ms || ms <= 0) return "Active now";
        const diff = Math.max(0, Math.floor((Date.now() - ms) / 1000));
        if (diff < 15) return "Just now";
        if (diff < 60) return diff + "s ago";
        const min = Math.floor(diff / 60);
        if (min < 60) return min + "m ago";
        const hr = Math.floor(min / 60);
        return hr + "h ago";
    }

    // ==========================================
    // STATE A: COLLAPSED CAPSULE
    // ==========================================
    Rectangle {
        id: capsuleBg
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width
        height: Preferences.barHeight
        radius: root.capsuleRadius
        color: Theme.withAlpha(Theme.base, 0.88)
        border.width: pillMouse.containsMouse || root.expanded ? 1.5 : 1
        border.color: root.expanded ? Theme.accent : pillMouse.containsMouse ? Theme.withAlpha(Theme.accent, 0.6) : Theme.withAlpha(Theme.surface1, 0.45)
        antialiasing: true

        Behavior on border.color { ColorAnimation { duration: Tokens.animFast } }
        Behavior on color { ColorAnimation { duration: Tokens.animFast } }

        RowLayout {
            id: contentRow
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 7

            // AI Application Icon
            Item {
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                Image {
                    id: appIcon
                    anchors.centerIn: parent
                    width: 18
                    height: 18
                    source: Quickshell.iconPath(root.iconName, true)
                    fillMode: Image.PreserveAspectFit
                    asynchronous: true
                    visible: status === Image.Ready
                }
                Icon {
                    anchors.centerIn: parent
                    icon: "smart_toy"
                    size: 17
                    color: Theme.accent
                    visible: appIcon.status !== Image.Ready
                }
            }

            // Primary Task Title
            PanelText {
                Layout.fillWidth: true
                Layout.minimumWidth: 40
                text: root.taskTitle ? root.taskTitle : root.appName
                font.pixelSize: 12
                font.weight: Font.DemiBold
                color: Theme.text
                elide: Text.ElideRight
            }

            // Agent Count Badge
            Rectangle {
                Layout.preferredHeight: 18
                Layout.preferredWidth: countText.implicitWidth + 10
                radius: 9
                color: Theme.withAlpha(Theme.accent, 0.16)
                visible: root.agentCount > 1
                PanelText {
                    id: countText
                    anchors.centerIn: parent
                    text: root.agentCount + " Agents"
                    font.pixelSize: 10
                    font.weight: Font.DemiBold
                    color: Theme.accent
                }
            }

            // Small Activity Glyph Indicator
            AgentGlyph {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                kind: root.kind
                running: root.active
            }

            // Expand Chevron Indicator
            Icon {
                Layout.preferredWidth: 14
                Layout.preferredHeight: 14
                icon: root.expanded ? "keyboard_arrow_up" : "keyboard_arrow_down"
                size: 14
                color: root.expanded ? Theme.accent : Theme.subtext
                opacity: 0.85
            }
        }

        // Tap to Expand MouseArea
        MouseArea {
            id: pillMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: root.toggleExpand()
        }
    }

    // ==========================================
    // STATE B: EXPANDED CARD STACK (OXYGENOS 16 LIVE ALERTS)
    // ==========================================
    Rectangle {
        id: cardsContainer
        y: Preferences.barHeight + 8
        anchors.horizontalCenter: capsuleBg.horizontalCenter
        width: 380
        height: Math.min(460, stackColumn.implicitHeight + 24)
        radius: 20
        color: Theme.withAlpha(Theme.base, 0.96)
        border.width: 1
        border.color: Theme.withAlpha(Theme.surface1, 0.7)
        antialiasing: true
        clip: true

        visible: opacity > 0.01
        opacity: root.expanded ? 1.0 : 0.0
        scale: root.expanded ? 1.0 : 0.94
        transformOrigin: Item.Top

        Behavior on opacity {
            NumberAnimation { duration: Tokens.reducedMotion ? 0 : 200; easing.type: Easing.OutCubic }
        }
        Behavior on scale {
            NumberAnimation { duration: Tokens.reducedMotion ? 0 : 240; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
        }
        Behavior on height {
            NumberAnimation { duration: Tokens.reducedMotion ? 0 : 220; easing.type: Easing.OutCubic }
        }

        ColumnLayout {
            id: stackColumn
            anchors.fill: parent
            anchors.margins: 12
            spacing: 10

            // Header Row
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 28

                // Pulsing Live Indicator Dot
                Rectangle {
                    Layout.preferredWidth: 8
                    Layout.preferredHeight: 8
                    radius: 4
                    color: root.kind === "waiting" ? Theme.yellow : Theme.accent
                    ActivityPulse {
                        anchors.centerIn: parent
                        width: 14
                        height: 14
                        running: root.expanded
                        visible: root.kind === "working"
                    }
                }

                // Section Title
                PanelText {
                    text: "AI Agent Live Alerts"
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    color: Theme.text
                }

                // Total Active Count Badge
                Rectangle {
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: totalBadgeText.implicitWidth + 10
                    radius: 9
                    color: Theme.withAlpha(Theme.accent, 0.18)
                    PanelText {
                        id: totalBadgeText
                        anchors.centerIn: parent
                        text: (AgentWork.tasks.length || 1) + (AgentWork.tasks.length === 1 ? " Task" : " Tasks")
                        font.pixelSize: 10
                        font.weight: Font.DemiBold
                        color: Theme.accent
                    }
                }

                Item { Layout.fillWidth: true }

                // Collapse Button
                IconButton {
                    icon: "close"
                    size: 14
                    label: "Collapse stack"
                    onClicked: IslandState.closeMenu()
                }
            }

            // Divider Line
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.withAlpha(Theme.surface1, 0.4)
            }

            // Stack of Task Cards
            Flickable {
                id: cardFlickable
                Layout.fillWidth: true
                Layout.preferredHeight: Math.min(360, cardColumn.implicitHeight)
                contentWidth: width
                contentHeight: cardColumn.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                ColumnLayout {
                    id: cardColumn
                    width: parent.width
                    spacing: 8

                    Repeater {
                        model: AgentWork.tasks

                        delegate: Rectangle {
                            id: taskCard
                            required property var modelData
                            required property int index

                            Layout.fillWidth: true
                            implicitHeight: cardContent.implicitHeight + 20
                            radius: 14
                            color: cardMouse.containsMouse ? Theme.withAlpha(Theme.surface0, 0.98) : Theme.withAlpha(Theme.surface0, 0.75)
                            border.width: cardMouse.containsMouse ? 1.5 : 1
                            border.color: cardMouse.containsMouse ? Theme.accent : Theme.withAlpha(Theme.surface1, 0.5)
                            antialiasing: true

                            Behavior on color { ColorAnimation { duration: Tokens.animFast } }
                            Behavior on border.color { ColorAnimation { duration: Tokens.animFast } }

                            ColumnLayout {
                                id: cardContent
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 6

                                // Row 1: App Info + Status Badge
                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 6

                                    // App Icon
                                    Image {
                                        Layout.preferredWidth: 16
                                        Layout.preferredHeight: 16
                                        source: Quickshell.iconPath(modelData.application_icon || "antigravity", true)
                                        fillMode: Image.PreserveAspectFit
                                        asynchronous: true
                                    }

                                    // App Name
                                    PanelText {
                                        text: modelData.application_name || "Agent"
                                        font.pixelSize: 11
                                        font.weight: Font.Bold
                                        color: Theme.subtext
                                    }

                                    // Agent Count on this Task
                                    Rectangle {
                                        Layout.preferredHeight: 16
                                        Layout.preferredWidth: cardAgentCountText.implicitWidth + 8
                                        radius: 8
                                        color: Theme.withAlpha(Theme.text, 0.08)
                                        visible: (modelData.active_agent_count || 1) > 1
                                        PanelText {
                                            id: cardAgentCountText
                                            anchors.centerIn: parent
                                            text: (modelData.active_agent_count || 1) + " Agents"
                                            font.pixelSize: 9
                                            font.weight: Font.DemiBold
                                            color: Theme.subtext
                                        }
                                    }

                                    Item { Layout.fillWidth: true }

                                    // Status Pill Badge
                                    Rectangle {
                                        Layout.preferredHeight: 18
                                        Layout.preferredWidth: statusRow.implicitWidth + 10
                                        radius: 9
                                        color: modelData.status === "waiting" ? Theme.withAlpha(Theme.yellow, 0.2) :
                                               modelData.status === "completed" ? Theme.withAlpha(Theme.green, 0.2) :
                                               modelData.status === "error" ? Theme.withAlpha(Theme.red, 0.2) :
                                               Theme.withAlpha(Theme.accent, 0.18)

                                        RowLayout {
                                            id: statusRow
                                            anchors.centerIn: parent
                                            spacing: 4

                                            AgentGlyph {
                                                Layout.preferredWidth: 12
                                                Layout.preferredHeight: 12
                                                kind: modelData.status || "working"
                                                running: true
                                            }

                                            PanelText {
                                                text: modelData.status_label || (modelData.status === "waiting" ? "Waiting for input" : modelData.status === "completed" ? "Completed" : "Working")
                                                font.pixelSize: 9
                                                font.weight: Font.DemiBold
                                                color: modelData.status === "waiting" ? Theme.yellow :
                                                       modelData.status === "completed" ? Theme.green :
                                                       modelData.status === "error" ? Theme.red :
                                                       Theme.accent
                                            }
                                        }
                                    }
                                }

                                // Row 2: Task Title
                                PanelText {
                                    Layout.fillWidth: true
                                    text: modelData.task_title || "Active Session"
                                    font.pixelSize: 13
                                    font.weight: Font.DemiBold
                                    color: Theme.text
                                    elide: Text.ElideRight
                                }

                                // Row 3: Task Description / Preview
                                PanelText {
                                    Layout.fillWidth: true
                                    text: (modelData.task_description && modelData.task_description !== modelData.task_title) ? modelData.task_description : "Session active in workspace"
                                    font.pixelSize: 11
                                    font.weight: Font.Normal
                                    color: Theme.subtext
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                }

                                // Row 4: Elapsed Time & Focus Button
                                RowLayout {
                                    Layout.fillWidth: true
                                    Layout.topMargin: 2
                                    spacing: 6

                                    // Elapsed time
                                    Icon {
                                        icon: "schedule"
                                        size: 12
                                        color: Theme.overlay1
                                    }
                                    PanelText {
                                        text: modelData.status === "working" ? "Active now" : root.formatTime(modelData.last_activity || modelData.started_at)
                                        font.pixelSize: 10
                                        color: Theme.overlay1
                                    }

                                    Item { Layout.fillWidth: true }

                                    // Click to Focus Window Pill
                                    Rectangle {
                                        Layout.preferredHeight: 22
                                        Layout.preferredWidth: focusBtnRow.implicitWidth + 12
                                        radius: 11
                                        color: cardMouse.containsMouse ? Theme.withAlpha(Theme.accent, 0.2) : Theme.withAlpha(Theme.text, 0.08)
                                        border.width: 1
                                        border.color: cardMouse.containsMouse ? Theme.accent : "transparent"

                                        RowLayout {
                                            id: focusBtnRow
                                            anchors.centerIn: parent
                                            spacing: 4
                                            Icon {
                                                icon: "open_in_new"
                                                size: 11
                                                color: cardMouse.containsMouse ? Theme.accent : Theme.subtext
                                            }
                                            PanelText {
                                                text: "Focus Window"
                                                font.pixelSize: 10
                                                font.weight: Font.Medium
                                                color: cardMouse.containsMouse ? Theme.accent : Theme.subtext
                                            }
                                        }
                                    }
                                }
                            }

                            // Card Click MouseArea
                            MouseArea {
                                id: cardMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: AgentWork.focusTask(taskCard.modelData)
                            }
                        }
                    }
                }
            }
        }
    }
}
