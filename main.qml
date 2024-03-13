import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480
    visible: true
    title: qsTr("Airplane Seat Control")

    ListView {
        id: modelContainerList

        anchors.left: parent.left
        width: 200
        height: 200
        model: settingListModel

        delegate: TextEdit {

            text: model.display.head

            onTextChanged: {
                model.display.head = text
            }
        }

        currentIndex: settingComboBox.currentIndex
    }

    Rectangle {
        width: 220
        height: 400

        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right

            rightMargin: 10
        }

        border {
            color: "green"
            width: 1
        }

        Column {
            padding: 10

            Row {
                id: modelSelector

                height: settingComboBox.height

                Label {
                    width: 50
                    height: parent.height

                    anchors.verticalCenter: settingComboBox.verticalCenter

                    color: "black"
                    text: "Setting: "

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
                              < 0 ? "please select" : settingComboBox.currentIndex
                    }

                    currentIndex: -1

                    onCurrentIndexChanged: {
                        if (currentIndex >= 0) {
                            settingContainer.load_setting(currentIndex)
                        }
                    }
                }
            }

            Row {
                height: 40

                Button {
                    width: 200
                    height: parent.height

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
                width: 200

                Rectangle {
                    border.color: "red"
                    border.width: 1

                    opacity: 0
                    anchors.fill: parent
                }

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
                    readonly property bool is_head_role: index === 0

                    readonly property real value: valueSlider.value
                    readonly property bool checked: !is_head_role
                                                    || checkbox.checked

                    function setValue(new_value) {
                        valueSlider.value = new_value
                    }

                    function setChecked(is_checked) {
                        checkbox.checked = is_checked
                    }

                    height: 70
                    width: 200

                    Label {
                        id: label

                        width: 50
                        height: parent.height

                        anchors {
                            verticalCenter: parent.verticalCenter
                            left: parent.left
                        }

                        color: "black"
                        text: get_label() + " "

                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft

                        function get_label() {
                            switch (index) {
                            case 0:
                                return "Head"
                            case 1:
                                return "Back"
                            case 2:
                                return "Foot"
                            case 3:
                                return "Hardness"
                            }
                        }
                    }

                    CheckBox {
                        id: checkbox

                        width: 20
                        height: 30

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: valueSlider.left
                            rightMargin: 10
                        }

                        visible: is_head_role

                        Rectangle {
                            border {
                                width: 1
                                color: checkbox.checked ? "lightgray" : "blue"
                            }

                            color: "transparent"
                            anchors.fill: checkbox.indicator
                        }

                        Label {
                            height: 20
                            width: 30

                            visible: !checkbox.checked

                            anchors {
                                verticalCenter: checkbox.indicator.verticalCenter
                                top: checkbox.indicator.bottom
                            }

                            color: "black"

                            text: "(detached)"
                        }

                        onCheckStateChanged: {
                            if (settingContainer.settingToModify) {
                                settingContainer.settingToModify.isHeadAttached = checked
                            }
                        }
                    }

                    Slider {
                        id: valueSlider

                        width: 120
                        height: parent.height

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        enabled: !is_head_role || checkbox.checked

                        from: 0
                        to: 100

                        value: 50

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

    Rectangle {
        color: "transparent"

        border {
            color: "red"
            width: 1
        }

        height: 400
        width: 400

        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }
    }
}
