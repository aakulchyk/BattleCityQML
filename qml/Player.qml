import QtQuick 2.0
import VPlay 2.0
Tank {
    focus: true
    isPlayer: true

    PlayerSpriteAnimation {
        id: sprites
        playerLevel: 1
        anchors.fill: parent
    }

    property alias controller: twoAxisController // we make the player's twoAxisController visible and accessible for the scene

    onIsDestroyedChanged: scene.startGameOverTimer()

    TwoAxisController {
        id: twoAxisController
        inputActionsToKeyCode: {
            "moveUp": Qt.Key_Up,
            "moveDown": Qt.Key_Down,
            "moveLeft": Qt.Key_Left,
            "moveRight": Qt.Key_Right,
            "fire": Qt.Key_Space
        }

        onInputActionPressed: {
            if (isDestroyed)
                return
            if (actionName == "fire") {
                parent.fire()
            }
            else {
                //console.log("coord: " + parent.x + " " + parent.y)
                tankMovingSound.muted = false
                tankStandingSound.muted = true
                switch (actionName) {
                    case "moveLeft":
                        parent.move(0); break;
                    case "moveUp":
                        parent.move(1); break;
                    case "moveRight":
                        parent.move(2); break;
                    case "moveDown":
                        parent.move(3); break;
                }
            }
        }

        onInputActionReleased: {
            parent.stopMoving()
            tankStandingSound.muted = false
            tankMovingSound.muted = true
        }
    }
}

