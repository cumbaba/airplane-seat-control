import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 540
    minimumWidth: 540
    maximumWidth: 540

    height: 440
    minimumHeight: 440
    maximumHeight: 440

    flags: Qt.FramelessWindowHint

    visible: true

    Rectangle {
        width: 440
        height: column.height

        anchors.centerIn: parent

        Column {
            id: column

            width: parent.width

            Row {
                height: settingSelector.height + 40
                spacing: 50

                ListView {
                    id: editorListView

                    property bool suppressReload: false

                    // This component is only used for editing the model through the role names
                    visible: false

                    model: settingListModel
                    delegate: ItemDelegate {
                        property var setting: model
                    }

                    currentIndex: settingSelector.currentIndex

                    onCurrentIndexChanged: {
                        if (!suppressReload && currentIndex >= 0) {
                            settingContainer.load_setting()
                        }
                    }
                }

                Label {
                    width: 50
                    height: parent.height

                    anchors.verticalCenter: parent.verticalCenter

                    color: favColor
                    text: "Setting: "

                    font.pixelSize: 20
                    font.bold: true

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                ComboBox {
                    id: settingSelector

                    width: 150
                    anchors.verticalCenter: parent.verticalCenter

                    model: settingListModel

                    contentItem: Text {
                        verticalAlignment: Text.AlignVCenter
                        text: settingSelector.currentIndex < 0 ? "Please select"
                                                               : "Setting "+ (settingSelector.currentIndex + 1)
                    }

                    delegate: ItemDelegate {
                        width: ListView.view.width
                        text: "Setting " + (index + 1)
                        palette.text: settingSelector.palette.text
                        palette.highlightedText: settingSelector.palette.highlightedText
                        font.bold: settingSelector.currentIndex === index
                        highlighted: settingSelector.highlightedIndex === index
                    }

                    currentIndex: -1
                }

                Button {
                    height: 40
                    width: 140

                    anchors.verticalCenter: parent.verticalCenter

                    contentItem: Label {
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        font.bold: true
                        color: favColor
                        text: "Add New"
                    }

                    background.opacity: pressed ? 0.1 : 1

                    onClicked: {
                        settingContainer.add_new_setting()

                        // Switch the suppression flag to prevent the flickering when adding a new setting
                        // Otherwise, the saved values will be reset for the sliders, which may cause a change in indicator
                        editorListView.suppressReload = true
                        settingSelector.currentIndex = settingListModel.rowCount() - 1
                        editorListView.suppressReload = false
                    }
                }
            }

            ListView {
                id: settingContainer

                height: 300
                width: parent.width

                spacing: 10
                interactive: false

                model: 4

                function load_setting() {
                    if (editorListView.currentIndex >= 0) {
                        itemAtIndex(0).setValue(
                                    editorListView.currentItem.setting.head)
                        itemAtIndex(0).setHeadRestToggle(
                                    editorListView.currentItem.setting.is_head_attached)
                        itemAtIndex(1).setValue(
                                    editorListView.currentItem.setting.back)
                        itemAtIndex(2).setValue(
                                    editorListView.currentItem.setting.foot)
                        itemAtIndex(3).setValue(
                                    editorListView.currentItem.setting.hardness)
                    }
                }

                function add_new_setting() {
                    settingListModel.addSetting(itemAtIndex(0).value,
                                                itemAtIndex(0).toggled,
                                                itemAtIndex(1).value,
                                                itemAtIndex(2).value,
                                                itemAtIndex(3).value)
                }

                delegate: Item {
                    readonly property bool isHead: index === 0
                    readonly property bool isHardness: index === 3

                    readonly property real value: slider.value
                    readonly property bool toggled: !isHead
                                                    || headRestToggleButton.toggled

                    function setValue(new_value) {
                        slider.value = new_value
                    }

                    function setHeadRestToggle(is_toggled) {
                        headRestToggleButton.toggled = is_toggled
                    }

                    height: 70
                    width: settingContainer.width

                    Label {
                        id: label

                        width: 50
                        height: parent.height

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }

                        color: favColor

                        font.pixelSize: 20
                        font.bold: true

                        text: get_label() + ":"

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft

                        function get_label() {
                            switch (index) {
                            case 0:
                                return "Headrest"
                            case 1:
                                return "Backrest"
                            case 2:
                                return "Footrest"
                            case 3:
                                return "Hardness"
                            }
                        }
                    }

                    Button {
                        id: headRestToggleButton

                        property bool toggled: true

                        width: 90
                        height: 40

                        visible: isHead

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: slider.left
                            rightMargin: 20
                        }

                        contentItem: Label {
                            verticalAlignment: Text.AlignVCenter
                            text: headRestToggleButton.toggled ? "Attached" : "Detached"
                            font.pixelSize: 14
                            font.bold: true

                            color: headRestToggleButton.toggled ? "green" : "red"
                        }

                        onClicked: toggled = !toggled

                        onToggledChanged: {
                            if (editorListView.currentIndex >= 0) {
                                editorListView.currentItem.setting.is_head_attached = toggled
                            }
                        }
                    }

                    ValueSlider {
                        id: slider

                        width: 240
                        height: parent.height

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        enabled: !isHead || headRestToggleButton.toggled

                        from: 0

                        to: isHead ? 40 : (isHardness ? 10 : 60)
                        unit: isHead || isHardness ? "" : "°"

                        onValueChanged: {
                            if (editorListView.currentIndex >= 0) {
                                switch (index) {
                                case 0:
                                    editorListView.currentItem.setting.head = value
                                    break
                                case 1:
                                    editorListView.currentItem.setting.back = value
                                    break
                                case 2:
                                    editorListView.currentItem.setting.foot = value
                                    break
                                case 3:
                                    editorListView.currentItem.setting.hardness = value
                                    break
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
