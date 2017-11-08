import QtQuick 2.0
import VPlay 2.0

Component {
    BasicObject {
        entityType: "eagle"
        removeAfterDestruction: false

        onIsDestroyedChanged: {
            if (isDestroyed) {
                eagleDestroyedSound.play()
                eagleSprites.jumpTo("eagleDestroyed")
                scene.startGameOverTimer()
            }
        }

        GameSpriteAnimation {
            id: eagleSprites

            SpriteVPlay {
                name: "eagleAlive"
                frameWidth: 16
                frameHeight: 16
                frameCount: 1
                startFrameRow: 3
                startFrameColumn: 20
            }

            SpriteVPlay {
                name: "eagleDestroyed"
                frameWidth: 16
                frameHeight: 16
                frameCount: 1
                startFrameRow: 3
                startFrameColumn: 21
            }
        }

        BoxCollider {
            anchors.fill: parent
            bodyType: Body.Static
            collisionTestingOnlyMode: parent.isDestroyed
            fixture.onContactChanged: {
                if (collisionTestingOnlyMode)
                    return
                var otherEntity = other.getBody().target
                var otherEntityType = otherEntity.entityType

                if (otherEntityType === "bullet") {
                    otherEntity.removeEntity()
                    parent.explode(true)
                    parent.isDestroyed = true
                }
            }
        }
    }
}
