import QtQuick 2.0

Rectangle {
    property string action
    visible: true
    width: parent.width / 2; height: width
    color: "green"
    border.color: "black"
    border.width: 5
    radius: 10

    MouseArea {
        anchors.fill:parent
        onPressedChanged: scene.player.controller.setInputActionPressedStatus(action, pressed)
    }
}
