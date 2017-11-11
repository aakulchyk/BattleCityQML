import QtQuick 2.0
import VPlay 2.0

Component
{
    EntityBase {
        entityType: "bullet"
        z: 2

        width: scene.gridSize/4
        height: scene.gridSize/4

        property point source
        property point destination
        property bool vertical: source.x == destination.x
        property int moveDuration
        property string ownerId

        property alias frameX: bulletSprite.frameX
        property alias frameY: bulletSprite.frameY

        Component.onCompleted: {
            if (Math.round(source.x) == Math.round(destination.x)) {
                if (Math.round(source.y) < Math.round(destination.y)) {
                    frameX = 20*16+16; frameY = 6*16+4
                }
                else {
                    frameX = 20*16; frameY = 6*16+4
                }
            }
            else if (Math.round(source.x) < Math.round(destination.x)) {
                frameX = 20*16+24; frameY = 6*16+4
            }
            else {
                frameX = 20*16+8; frameY = 6*16+4
            }
        }

        PropertyAnimation on x {
            id: animX
            from: source.x
            to: destination.x
            duration: moveDuration
        }

        PropertyAnimation on y {
            id: animY
            from: source.y
            to: destination.y
            duration: moveDuration
        }


        AnimatedSpriteVPlay {
            id: bulletSprite
            anchors.fill: parent

            source: "../assets/img/spriteSheet16x16.png"
            frameWidth: 8
            frameHeight: 8
        }


        BoxCollider
        {
            width: bulletSprite.width
            height: bulletSprite.height
            bullet: true
            collisionTestingOnlyMode: true
            fixture.onContactChanged: {
                var otherEntity = other.getBody().target
                var otherEntityType = otherEntity.entityType

                if (otherEntityType === "bullet") {
                    otherEntity.removeEntity()
                    bulletHitWallSound.play()
                }
            }
        }
    }
}
