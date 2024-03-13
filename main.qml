import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    width: 640
    height: 480

    minimumWidth: 440
    minimumHeight: 400

    visible: true
    title: qsTr("Airplane Seat Control")

    Rectangle {

        width: 440
        height: 400

        anchors.centerIn: parent

        border {
            color: "green"
            width: 1
        }

        Column {
            padding: 10
            width: 350

            anchors.horizontalCenter: parent.horizontalCenter

            Row {
                id: modelSelector

                height: settingComboBox.height
                anchors.horizontalCenter: parent.horizontalCenter

                spacing: 50

                Label {
                    width: 50
                    height: parent.height

                    anchors.verticalCenter: settingComboBox.verticalCenter

                    color: "black"
                    text: "Setting: "

                    font.pixelSize: 20

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


            Button {
                height: 40
                width: 300

                anchors.horizontalCenter: parent.horizontalCenter

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

            ListView {
                id: settingContainer

                property var settingToModify: undefined

                height: 300
                width: parent.width

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
                        text: get_label() + ":"

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

                        width: 30
                        height: 40

                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: valueSlider.left
                            rightMargin: 20
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
                            font.pixelSize: 16

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

                        width: 240
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
}
