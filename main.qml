import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    readonly property color favColor: "#05164D"

    width: 640
    height: 480

    minimumWidth: 640
    minimumHeight: 480

    visible: true
    title: qsTr("Airplane Seat Control")

    Rectangle {

        width: 440
        height: column.height

        anchors.centerIn: parent

        Column {
            id: column
            width: parent.width

            Row {
                height: settingSelector.height

                spacing: 50

                Label {
                    width: 50
                    height: parent.height

                    anchors.verticalCenter: settingSelector.verticalCenter

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

                    model: settingListModel

                    contentItem: Text {
                        text: settingSelector.currentIndex
                              < 0 ? "Please select" : "Setting " + (settingSelector.currentIndex + 1)
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

                    onCurrentIndexChanged: {
                        if (currentIndex >= 0) {
                            settingContainer.load_setting(currentIndex)
                        }
                    }
                }

                Button {
                    height: 40
                    width: 140

                    anchors.verticalCenter: parent.verticalCenter

                    contentItem: IconLabel {
                        font.pixelSize: 16
                        font.bold: true
                        text: "Add New"
                    }

                    background.opacity: pressed ? 0.1 : 1

                    onClicked: {
                        settingContainer.add_new_setting()
                        settingSelector.currentIndex = settingListModel.rowCount(
                                    ) - 1
                    }
                }
            }

            ListView {
                id: settingContainer

                property var settingToModify: undefined

                height: 300
                width: parent.width

                spacing: 10
                interactive: false

                model: 4

                function load_setting(modelIndex) {
                    settingToModify = settingListModel.data(
                                settingListModel.index(modelIndex, 0))

                    if (settingToModify) {
                        itemAtIndex(0).setValue(settingToModify.head)
                        itemAtIndex(0).setHeadRestToggle(settingToModify.isHeadAttached)
                        itemAtIndex(1).setValue(settingToModify.back)
                        itemAtIndex(2).setValue(settingToModify.foot)
                        itemAtIndex(3).setValue(settingToModify.hardness)
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

                        visible: index === 0

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: slider.left
                            rightMargin: 20
                        }

                        contentItem: IconLabel {
                            text: headRestToggleButton.toggled ? "Attached" : "Detached"
                            font.pixelSize: 14
                            font.bold: true

                            color: headRestToggleButton.toggled ? "green" : "red"
                        }

                        onClicked: toggled = !toggled

                        onToggledChanged: {
                            if (settingContainer.settingToModify) {
                                settingContainer.settingToModify.isHeadAttached = toggled
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
                        unit: isHead || isHardness  ? "" : "°"

                        onValueChanged: {
                            if (settingContainer.settingToModify) {
                                switch (index) {
                                case 0:
                                    settingContainer.settingToModify.head = value
                                    break
                                case 1:
                                    settingContainer.settingToModify.back = value
                                    break
                                case 2:
                                    settingContainer.settingToModify.foot = value
                                    break
                                case 3:
                                    settingContainer.settingToModify.hardness = value
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
