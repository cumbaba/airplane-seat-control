import QtQuick 2.15
import QtQuick.Controls 2.15

Slider {
    id: control

    property string unit: ""

    width: 240
    height: 50

    from: 0
    to: 100
    stepSize: 1

    value: 50

    Label {
        text: from + unit

        anchors {
            verticalCenter: parent.verticalCenter
            right: control.left
            rightMargin: 6
        }

        font.pixelSize: 16
        font.bold: true
    }

    Label {
        text: to + unit

        anchors {
            verticalCenter: parent.verticalCenter
            left: control.right
            leftMargin: 6
        }

        font.pixelSize: 16
        font.bold: true
    }

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 20
        width: control.availableWidth
        height: implicitHeight
        radius: 6

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: parent.radius
            color: "#05164D"
        }

        Rectangle {
            z: 1
            anchors.fill: parent
            opacity: enabled ? 0 : 0.8
            color: "white"
        }

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop {
                position: 0.0
                color: "lightgray"
            }
            GradientStop {
                position: 1.0
                color: "#9C9C9C"
            }
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 12
        implicitHeight: 24
        radius: 2
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#9CA1B1"

        Label {
            text: (stepSize === 1 ? value : value.toFixed(1)) + unit

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.top
                bottomMargin: 6
            }

            font.pixelSize: 12
            font.bold: true
            visible: pressed
        }

        Rectangle {
            z: 1
            anchors.fill: parent
            opacity: enabled ? 0 : 0.8
            color: "white"
        }
    }
}