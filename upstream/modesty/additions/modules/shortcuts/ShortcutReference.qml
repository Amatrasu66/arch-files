import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.services
import qs.components
import qs.theme

PanelWindow {
    id: window

    screen: Quickshell.screens.find(s => s.name === Quickshell.env("MODESTY_SCREEN")) ?? Quickshell.screens[0]
    implicitWidth: screen?.width ?? 1920
    implicitHeight: screen?.height ?? 1080
    color: "transparent"

    property bool opened: false
    visible: opened || card.opacity > 0.01

    WlrLayershell.namespace: "modesty-shortcut-reference"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: opened ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusiveZone: 0

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    mask: Region {
        item: window.opened ? windowArea : null
    }

    Item { id: windowArea; anchors.fill: parent }

    function open(): void {
        opened = true;
        reload();
        searchField.forceActiveFocus();
    }

    function close(): void {
        opened = false;
    }

    function toggle(): void {
        if (opened) close();
        else open();
    }

    function reload(): void {
        if (registryFile) {
            try {
                registryFile.reload();
            } catch (e) {
                console.log("Error reloading registryFile: " + e);
            }
        }
    }

    // Registry data holder
    property var registryData: ({ "total": 0, "categories": [], "shortcuts": [] })
    property string activeCategory: "All Shortcuts"
    property string searchQuery: ""
    property string copiedChord: ""

    // Read centralized shortcut registry with auto-reload on file change
    FileView {
        id: registryFile
        path: (Quickshell.env("XDG_CONFIG_HOME") || Quickshell.env("HOME") + "/.config") + "/quickshell/config/shortcuts/shortcut_registry.json"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
        onLoaded: {
            try {
                const data = JSON.parse(text());
                if (data && data.shortcuts) {
                    window.registryData = data;
                }
            } catch (e) {
                console.log("Error loading shortcut registry: " + e);
            }
        }
    }

    Process {
        id: clipboardWriter
        command: ["wl-copy", window.copiedChord]
    }

    function copyShortcut(chord): void {
        window.copiedChord = chord;
        clipboardWriter.running = true;
        copyFeedbackTimer.restart();
    }

    Timer {
        id: copyFeedbackTimer
        interval: 1800
        onTriggered: window.copiedChord = ""
    }

    Component.onCompleted: {
        reload();
    }

    // Backdrop dismissal
    Rectangle {
        id: backdrop
        anchors.fill: parent
        color: "#11111b"
        opacity: window.opened ? 0.65 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

        MouseArea {
            anchors.fill: parent
            onClicked: window.close()
        }
    }

    // Filtered shortcuts calculation
    readonly property var filteredShortcuts: {
        const query = searchQuery.trim().toLowerCase();
        const list = registryData.shortcuts || [];
        
        return list.filter(item => {
            // Category match
            if (activeCategory !== "All Shortcuts" && item.category !== activeCategory) {
                return false;
            }
            if (!query) return true;

            const action = (item.action || "").toLowerCase();
            const desc = (item.description || "").toLowerCase();
            const app = (item.application || "").toLowerCase();
            const cat = (item.category || "").toLowerCase();
            const chord = (item.keys || []).join(" ").toLowerCase();

            return action.includes(query) ||
                   desc.includes(query) ||
                   app.includes(query) ||
                   cat.includes(query) ||
                   chord.includes(query);
        });
    }

    // Centered Modal Card
    Rectangle {
        id: card
        width: Math.min(window.width - 64, 980)
        height: Math.min(window.height - 80, 700)
        anchors.centerIn: parent
        radius: 20
        color: Theme.bgSolid
        border.width: 1
        border.color: Theme.withAlpha(Theme.text, 0.12)
        clip: true

        opacity: window.opened ? 1.0 : 0.0
        scale: window.opened ? 1.0 : 0.96
        Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on scale { NumberAnimation { duration: 240; easing.type: Easing.OutBack } }

        // Keyboard navigation inside card
        focus: window.opened
        Keys.onEscapePressed: window.close()
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                window.close();
                event.accepted = true;
            } else if ((event.modifiers & Qt.ControlModifier) && (event.key === Qt.Key_F || event.key === Qt.Key_K)) {
                searchField.forceActiveFocus();
                searchField.selectAll();
                event.accepted = true;
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            // -------------------------------------------------------------
            // 1. HEADER SECTION
            // -------------------------------------------------------------
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 74
                color: Theme.surfaceSolid
                border.width: 0

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 20
                    spacing: 16

                    Rectangle {
                        width: 44
                        height: 44
                        radius: 12
                        color: Theme.withAlpha(Theme.accent, 0.15)
                        border.width: 1
                        border.color: Theme.withAlpha(Theme.accent, 0.3)

                        Icon {
                            anchors.centerIn: parent
                            icon: "keyboard"
                            size: 24
                            color: Theme.accent
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        RowLayout {
                            spacing: 10
                            PanelText {
                                text: "Keyboard Shortcuts"
                                font.pixelSize: 18
                                font.weight: Font.Bold
                                color: Theme.text
                            }

                            Rectangle {
                                implicitWidth: countLabel.implicitWidth + 14
                                implicitHeight: 22
                                radius: 11
                                color: Theme.withAlpha(Theme.accent, 0.18)
                                border.width: 1
                                border.color: Theme.withAlpha(Theme.accent, 0.35)

                                PanelText {
                                    id: countLabel
                                    anchors.centerIn: parent
                                    text: (window.registryData.total || 0) + " Shortcuts"
                                    font.pixelSize: 11
                                    font.weight: Font.DemiBold
                                    color: Theme.accent
                                }
                            }
                        }

                        PanelText {
                            text: "Universal Desktop Shortcut Reference · Single Source of Truth"
                            font.pixelSize: 12
                            color: Theme.subtext
                        }
                    }

                    IconButton {
                        icon: "close"
                        size: 20
                        label: "Close Shortcut Reference (Esc)"
                        onClicked: window.close()
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Theme.withAlpha(Theme.text, 0.08)
                }
            }

            // -------------------------------------------------------------
            // 2. SEARCH BAR SECTION
            // -------------------------------------------------------------
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 58
                color: Theme.bgSolid

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 24
                    anchors.rightMargin: 24
                    spacing: 12

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.topMargin: 8
                        Layout.bottomMargin: 8
                        radius: 12
                        color: Theme.surfaceSolid
                        border.width: searchField.activeFocus ? 1.5 : 1
                        border.color: searchField.activeFocus ? Theme.accent : Theme.withAlpha(Theme.text, 0.1)

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 12
                            anchors.rightMargin: 12
                            spacing: 10

                            Icon {
                                icon: "search"
                                size: 18
                                color: searchField.activeFocus ? Theme.accent : Theme.subtext
                            }

                            TextInput {
                                id: searchField
                                Layout.fillWidth: true
                                text: window.searchQuery
                                onTextChanged: window.searchQuery = text
                                color: Theme.text
                                font.family: Tokens.font
                                font.pixelSize: 13
                                selectByMouse: true
                                selectionColor: Theme.accent
                                selectedTextColor: Theme.bgSolid
                                clip: true

                                PanelText {
                                    anchors.fill: parent
                                    verticalAlignment: Text.AlignVCenter
                                    text: "Search by action, key, app, or keyword... (Ctrl+F)"
                                    color: Theme.withAlpha(Theme.text, 0.35)
                                    font.pixelSize: 13
                                    visible: !searchField.text
                                }

                                Keys.onEscapePressed: {
                                    if (text) {
                                        text = "";
                                    } else {
                                        window.close();
                                    }
                                }
                            }

                            IconButton {
                                visible: !!searchField.text
                                icon: "cancel"
                                size: 16
                                label: "Clear Search"
                                onClicked: searchField.text = ""
                            }
                        }
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: 1
                    color: Theme.withAlpha(Theme.text, 0.08)
                }
            }

            // -------------------------------------------------------------
            // 3. MAIN TWO-COLUMN BODY
            // -------------------------------------------------------------
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 0

                // Left Sidebar: Categories
                Rectangle {
                    Layout.preferredWidth: 230
                    Layout.fillHeight: true
                    color: Theme.withAlpha(Theme.surfaceSolid, 0.5)

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.topMargin: 12
                        anchors.bottomMargin: 12
                        spacing: 8

                        PanelText {
                            Layout.leftMargin: 18
                            text: "CATEGORIES"
                            font.pixelSize: 11
                            font.weight: Font.Bold
                            color: Theme.withAlpha(Theme.text, 0.45)
                        }

                        Flickable {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            contentHeight: categoryCol.implicitHeight
                            clip: true

                            ColumnLayout {
                                id: categoryCol
                                width: parent.width
                                spacing: 4

                                // All Shortcuts item
                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.leftMargin: 12
                                    Layout.rightMargin: 12
                                    implicitHeight: 36
                                    radius: 10
                                    color: window.activeCategory === "All Shortcuts" ? Theme.withAlpha(Theme.accent, 0.16) :
                                           catMouseAll.hovered ? Theme.withAlpha(Theme.text, 0.06) : "transparent"
                                    border.width: window.activeCategory === "All Shortcuts" ? 1 : 0
                                    border.color: Theme.withAlpha(Theme.accent, 0.35)

                                    MouseArea {
                                        id: catMouseAll
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: window.activeCategory = "All Shortcuts"
                                    }

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.leftMargin: 10
                                        anchors.rightMargin: 10
                                        spacing: 8

                                        Icon {
                                            icon: "apps"
                                            size: 16
                                            color: window.activeCategory === "All Shortcuts" ? Theme.accent : Theme.subtext
                                        }

                                        PanelText {
                                            Layout.fillWidth: true
                                            text: "All Shortcuts"
                                            font.pixelSize: 12
                                            font.weight: window.activeCategory === "All Shortcuts" ? Font.Bold : Font.Normal
                                            color: window.activeCategory === "All Shortcuts" ? Theme.text : Theme.subtext
                                            elide: Text.ElideRight
                                        }

                                        PanelText {
                                            text: String(window.registryData.total || 0)
                                            font.pixelSize: 11
                                            color: Theme.withAlpha(Theme.text, 0.4)
                                        }
                                    }
                                }

                                // Category Repeater
                                Repeater {
                                    model: window.registryData.categories || []

                                    Rectangle {
                                        id: catBtn
                                        required property string modelData
                                        Layout.fillWidth: true
                                        Layout.leftMargin: 12
                                        Layout.rightMargin: 12
                                        implicitHeight: 36
                                        radius: 10
                                        color: window.activeCategory === modelData ? Theme.withAlpha(Theme.accent, 0.16) :
                                               catMouse.hovered ? Theme.withAlpha(Theme.text, 0.06) : "transparent"
                                        border.width: window.activeCategory === modelData ? 1 : 0
                                        border.color: Theme.withAlpha(Theme.accent, 0.35)

                                        readonly property int catCount: {
                                            const list = window.registryData.shortcuts || [];
                                            return list.filter(i => i.category === modelData).length;
                                        }

                                        function getCategoryIcon(name): string {
                                            const icons = {
                                                "System & Desktop": "computer",
                                                "Niri Window Management": "grid_view",
                                                "Workspaces": "splitscreen",
                                                "Modesty Dynamic Island": "web_asset",
                                                "Quick Settings": "tune",
                                                "Media & Audio": "music_note",
                                                "Display & Brightness": "brightness_6",
                                                "Power & Session": "power_settings_new",
                                                "Kitty Terminal": "terminal",
                                                "Browsers": "public",
                                                "File Manager": "folder",
                                                "Development Tools": "code",
                                                "Screenshots & Utilities": "crop"
                                            };
                                            return icons[name] || "widgets";
                                        }

                                        MouseArea {
                                            id: catMouse
                                            anchors.fill: parent
                                            hoverEnabled: true
                                            onClicked: window.activeCategory = catBtn.modelData
                                        }

                                        RowLayout {
                                            anchors.fill: parent
                                            anchors.leftMargin: 10
                                            anchors.rightMargin: 10
                                            spacing: 8

                                            Icon {
                                                icon: catBtn.getCategoryIcon(catBtn.modelData)
                                                size: 16
                                                color: window.activeCategory === catBtn.modelData ? Theme.accent : Theme.subtext
                                            }

                                            PanelText {
                                                Layout.fillWidth: true
                                                text: catBtn.modelData
                                                font.pixelSize: 12
                                                font.weight: window.activeCategory === catBtn.modelData ? Font.Bold : Font.Normal
                                                color: window.activeCategory === catBtn.modelData ? Theme.text : Theme.subtext
                                                elide: Text.ElideRight
                                            }

                                            PanelText {
                                                text: String(catBtn.catCount)
                                                font.pixelSize: 11
                                                color: Theme.withAlpha(Theme.text, 0.4)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        anchors.right: parent.right
                        width: 1
                        height: parent.height
                        color: Theme.withAlpha(Theme.text, 0.08)
                    }
                }

                // Right Content Area: Shortcut Rows
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 0

                    // Results Subheader
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 40
                        color: Theme.bgSolid

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 20
                            anchors.rightMargin: 20

                            PanelText {
                                text: window.activeCategory + (window.searchQuery ? " · Search: \"" + window.searchQuery + "\"" : "")
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                                color: Theme.accent
                            }

                            Item { Layout.fillWidth: true }

                            PanelText {
                                text: window.filteredShortcuts.length + " matching"
                                font.pixelSize: 11
                                color: Theme.subtext
                            }
                        }

                        Rectangle {
                            anchors.bottom: parent.bottom
                            width: parent.width
                            height: 1
                            color: Theme.withAlpha(Theme.text, 0.06)
                        }
                    }

                    // Shortcut List View
                    ListView {
                        id: shortcutListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: window.filteredShortcuts
                        spacing: 6
                        boundsBehavior: Flickable.StopAtBounds

                        ScrollBar.vertical: ScrollBar {
                            policy: ScrollBar.AsNeeded
                        }

                        delegate: Rectangle {
                            id: rowCard
                            required property var modelData
                            width: shortcutListView.width - 24
                            x: 12
                            implicitHeight: 62
                            radius: 12
                            color: rowMouse.hovered ? Theme.withAlpha(Theme.text, 0.06) : Theme.surfaceSolid
                            border.width: 1
                            border.color: rowMouse.hovered ? Theme.withAlpha(Theme.accent, 0.3) : Theme.withAlpha(Theme.text, 0.06)

                            MouseArea {
                                id: rowMouse
                                anchors.fill: parent
                                hoverEnabled: true
                            }

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: 16
                                anchors.rightMargin: 16
                                spacing: 14

                                // Keycap Sequence
                                Row {
                                    spacing: 4
                                    Layout.preferredWidth: 230
                                    Layout.alignment: Qt.AlignVCenter

                                    Repeater {
                                        model: rowCard.modelData.keys || []

                                        Row {
                                            spacing: 4
                                            required property string modelData
                                            required property int index

                                            Rectangle {
                                                implicitWidth: keyLabel.implicitWidth + 14
                                                implicitHeight: 28
                                                radius: 6
                                                color: Theme.withAlpha(Theme.text, 0.12)
                                                border.width: 1
                                                border.color: Theme.withAlpha(Theme.text, 0.22)

                                                PanelText {
                                                    id: keyLabel
                                                    anchors.centerIn: parent
                                                    text: parent.parent.modelData.toUpperCase()
                                                    font.family: "JetBrainsMono Nerd Font"
                                                    font.pixelSize: 11
                                                    font.weight: Font.Bold
                                                    color: Theme.text
                                                }
                                            }

                                            PanelText {
                                                visible: parent.index < (rowCard.modelData.keys || []).length - 1
                                                text: "+"
                                                font.pixelSize: 12
                                                font.weight: Font.Bold
                                                color: Theme.withAlpha(Theme.text, 0.4)
                                                anchors.verticalCenter: parent.verticalCenter
                                            }
                                        }
                                    }
                                }

                                // Action and Description
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    Layout.alignment: Qt.AlignVCenter
                                    spacing: 2

                                    RowLayout {
                                        spacing: 8
                                        PanelText {
                                            text: rowCard.modelData.action || ""
                                            font.pixelSize: 13
                                            font.weight: Font.Medium
                                            color: Theme.text
                                            elide: Text.ElideRight
                                        }

                                        // Scope Badge
                                        Rectangle {
                                            implicitWidth: scopeLabel.implicitWidth + 8
                                            implicitHeight: 18
                                            radius: 4
                                            color: rowCard.modelData.scope === "global" ? Theme.withAlpha(Theme.accent, 0.15) : Theme.withAlpha(Theme.text, 0.08)
                                            border.width: 1
                                            border.color: rowCard.modelData.scope === "global" ? Theme.withAlpha(Theme.accent, 0.3) : "transparent"

                                            PanelText {
                                                id: scopeLabel
                                                anchors.centerIn: parent
                                                text: rowCard.modelData.scope === "global" ? "Global" : "App"
                                                font.pixelSize: 9
                                                font.weight: Font.DemiBold
                                                color: rowCard.modelData.scope === "global" ? Theme.accent : Theme.subtext
                                            }
                                        }
                                    }

                                    PanelText {
                                        Layout.fillWidth: true
                                        text: rowCard.modelData.description || ""
                                        font.pixelSize: 11
                                        color: Theme.subtext
                                        elide: Text.ElideRight
                                    }
                                }

                                // Application Badge
                                Rectangle {
                                    implicitWidth: appLabel.implicitWidth + 10
                                    implicitHeight: 22
                                    radius: 6
                                    color: Theme.withAlpha(Theme.text, 0.06)
                                    border.width: 1
                                    border.color: Theme.withAlpha(Theme.text, 0.1)

                                    PanelText {
                                        id: appLabel
                                        anchors.centerIn: parent
                                        text: rowCard.modelData.application || ""
                                        font.pixelSize: 10
                                        font.weight: Font.Medium
                                        color: Theme.subtext
                                    }
                                }

                                // Copy Chord Button
                                Rectangle {
                                    implicitWidth: 32
                                    implicitHeight: 32
                                    radius: 8
                                    color: copyMouse.hovered ? Theme.withAlpha(Theme.accent, 0.2) : "transparent"
                                    border.width: 1
                                    border.color: copyMouse.hovered ? Theme.accent : Theme.withAlpha(Theme.text, 0.1)

                                    readonly property string chordStr: (rowCard.modelData.keys || []).join(" + ")
                                    readonly property bool isJustCopied: window.copiedChord === chordStr

                                    Icon {
                                        anchors.centerIn: parent
                                        icon: parent.isJustCopied ? "check" : "content_copy"
                                        size: 16
                                        color: parent.isJustCopied ? Theme.green : (copyMouse.hovered ? Theme.accent : Theme.subtext)
                                    }

                                    MouseArea {
                                        id: copyMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        onClicked: window.copyShortcut(parent.chordStr)
                                    }
                                }
                            }
                        }

                        // Empty State Display
                        Item {
                            anchors.centerIn: parent
                            width: 300
                            height: 180
                            visible: window.filteredShortcuts.length === 0

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 10

                                Icon {
                                    Layout.alignment: Qt.AlignHCenter
                                    icon: "search_off"
                                    size: 40
                                    color: Theme.withAlpha(Theme.text, 0.3)
                                }

                                PanelText {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "No shortcuts match your search"
                                    font.pixelSize: 14
                                    font.weight: Font.Medium
                                    color: Theme.text
                                }

                                PanelText {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Try searching for a key name (e.g. 'Super') or app"
                                    font.pixelSize: 12
                                    color: Theme.subtext
                                }

                                ActionButton {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "Clear Search Filter"
                                    onClicked: {
                                        searchField.text = "";
                                        window.activeCategory = "All Shortcuts";
                                    }
                                }
                            }
                        }
                    }
                }
            }

            // -------------------------------------------------------------
            // 4. FOOTER STATUS BAR
            // -------------------------------------------------------------
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 38
                color: Theme.surfaceSolid

                Rectangle {
                    anchors.top: parent.top
                    width: parent.width
                    height: 1
                    color: Theme.withAlpha(Theme.text, 0.08)
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 20
                    anchors.rightMargin: 20

                    // Navigation Hints
                    Row {
                        spacing: 12
                        PanelText {
                            text: "[ Esc ] Close   ·   [ Ctrl+F ] Focus Search   ·   [ Copy ] Copy Chord"
                            font.pixelSize: 11
                            color: Theme.subtext
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Copied notification / Live Sync Status
                    RowLayout {
                        spacing: 6
                        Rectangle {
                            visible: !!window.copiedChord
                            implicitWidth: copiedText.implicitWidth + 12
                            implicitHeight: 20
                            radius: 4
                            color: Theme.withAlpha(Theme.green, 0.2)
                            border.width: 1
                            border.color: Theme.green

                            PanelText {
                                id: copiedText
                                anchors.centerIn: parent
                                text: "Copied: " + window.copiedChord
                                font.pixelSize: 10
                                font.weight: Font.Bold
                                color: Theme.green
                            }
                        }

                        Icon {
                            icon: "sync"
                            size: 14
                            color: Theme.withAlpha(Theme.text, 0.4)
                        }

                        PanelText {
                            text: "Live Synced: Niri & Modesty"
                            font.pixelSize: 10
                            color: Theme.withAlpha(Theme.text, 0.45)
                        }
                    }
                }
            }
        }
    }
}
