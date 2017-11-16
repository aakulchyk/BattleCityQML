import QtQuick 2.0
import VPlay 2.0

Component {
    BasicObject {
        z: 10
        entityType: "bonus"

        destroyable: false
        tankPassable: true
        bulletPassable: true

        property alias spriteColumn: bonusSprite.startFrameColumn
        property string type

        onTypeChanged: {
            bonusBlinkTimer.start()
            switch (type) {
            case "helmet":
                spriteColumn = 17
                break
            case "clock":
                spriteColumn = 18
                break
            case "shovel":
                spriteColumn = 19
                break
            case "star":
                spriteColumn = 20
                break
            case "grenade":
                spriteColumn = 21
                break
            case "tank":
                spriteColumn = 22
                break
            case "gun":
                spriteColumn = 23
                break
            }
        }

        Timer {
            id: bonusBlinkTimer
            interval: 500
            repeat: true
            onTriggered: {
                console.log("bonus: trigger visibility " + parent.opacity)
                if (parent.opacity > 0.99)
                    parent.opacity = 0.0
                else
                    parent.opacity = 1.0
            }

        }

        AnimatedSpriteVPlay {
            id: bonusSprite
            anchors.fill: parent
            source: "../assets/img/spriteSheet16x16.png"
            frameWidth: 16
            frameHeight: 16
            startFrameRow: 8
        }

        BoxCollider {
            id: bonusCollider
            anchors.fill: parent
            collisionTestingOnlyMode: true
            fixture.onBeginContact: {
                var otherEntity = other.getBody().target
                var otherEntityType = otherEntity.entityType
                if (otherEntityType === "tank" && otherEntity.isPlayer) {
                    bonusSound.play()
                    parent.removeEntity()
                }
            }
        }
    }
}
