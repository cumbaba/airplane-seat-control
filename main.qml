import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
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
                id: modelSelector

                height: settingComboBox.height

                spacing: 50

                Label {
                    width: 50
                    height: parent.height

                    anchors.verticalCenter: settingComboBox.verticalCenter

                    color: "black"
                    text: "Setting: "

                    font.pixelSize: 20
                    font.bold: true

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                }

                ComboBox {
                    id: settingComboBox

                    width: 150

                    model: settingListModel

                    textRole: "index"

                    contentItem: Text {
                        text: settingComboBox.currentIndex
                              < 0 ? "Select" : "Setting "
                                    + (settingComboBox.currentIndex + 1)
                    }

                    delegate: ItemDelegate {
                        width: ListView.view.width
                        text: "Setting " + (index + 1)
                        palette.text: settingComboBox.palette.text
                        palette.highlightedText: settingComboBox.palette.highlightedText
                        font.bold: settingComboBox.currentIndex === index
                        highlighted: settingComboBox.highlightedIndex === index
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
                        text: "Add New"
                    }

                    background.opacity: pressed ? 0.1 : 1

                    onClicked: {
                        settingContainer.save_current_setting()
                        settingComboBox.currentIndex = settingListModel.rowCount(
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

                // exclude the is_head_attached flag
                model: 4

                function load_setting(modelIndex) {
                    settingToModify = settingListModel.data(
                                settingListModel.index(modelIndex, 0))

                    if (settingToModify) {
                        itemAtIndex(0).setValue(settingToModify.head)
                        itemAtIndex(0).setChecked(
                                    settingToModify.isHeadAttached)
                        itemAtIndex(1).setValue(settingToModify.back)
                        itemAtIndex(2).setValue(settingToModify.foot)
                        itemAtIndex(3).setValue(settingToModify.hardness)
                    }
                }

                function save_current_setting() {
                    settingListModel.addSetting(itemAtIndex(0).value,
                                                itemAtIndex(0).checked,
                                                itemAtIndex(1).value,
                                                itemAtIndex(2).value,
                                                itemAtIndex(3).value)
                }

                delegate: Item {
                    readonly property bool isHeadRole: index === 0

                    readonly property real value: valueSlider.value
                    readonly property bool checked: !isHeadRole
                                                    || checkbox.checked

                    function setValue(new_value) {
                        valueSlider.value = new_value
                    }

                    function setChecked(is_checked) {
                        checkbox.checked = is_checked
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

                        color: "black"

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

                    CheckBox {
                        id: checkbox

                        width: 30
                        height: 30

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: valueSlider.left
                            rightMargin: 60
                        }

                        visible: isHeadRole
                        checked: true

                        contentItem: Rectangle {
                            radius: 3
                            anchors.fill: parent

                            Label {
                                anchors.verticalCenter: parent.verticalCenter

                                text: checkbox.checked ? "ON" : "OFF"
                                font.pointSize: 20
                                font.bold: true
                                color: checkbox.checked ? "green" : "red"
                            }
                        }

                        onCheckStateChanged: {
                            if (settingContainer.settingToModify) {
                                settingContainer.settingToModify.isHeadAttached = checked
                            }
                        }
                    }

                    ValueSlider {
                        id: valueSlider

                        width: 240
                        height: parent.height

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        enabled: !isHeadRole || checkbox.checked

                        from: 0

                        to: isHeadRole ? 40 : (index === 1 || index === 2 ? 60 : (index === 3 ? 10 : 100))
                        stepSize: index === 3 ? 0.1 : 1
                        unit: index === 1 || index === 2 ? "°" : ""

                        value: to / 2

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
