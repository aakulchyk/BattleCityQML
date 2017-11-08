import QtQuick 2.0
import VPlay 2.0

Component {
    BasicObject
    {
        entityType: "wall"

        property string type
        property alias spriteRow: wallSprite.startFrameRow
        property alias spriteColumn: wallSprite.startFrameColumn
        property alias spriteFrames: wallSprite.frameCount

        onTypeChanged: {
            switch (type) {
            case "brick":
                destroyable = true
                bulletPassable = tankPassable = false
                spriteRow = 1; spriteColumn = 17
                break
            case "concrete":
                destroyable = false
                bulletPassable = tankPassable = false
                spriteRow = 2; spriteColumn = 17
                break
            case "water":
                destroyable = false
                tankPassable = false
                bulletPassable = true
                //spriteFrames = 2
                spriteRow = 4; spriteColumn = 17
                wallSprite.frameCount = 2
                wallSprite.frameRate = 1
                wallSprite.running = true
                //wallSprite.loops = 1000
                wallSprite.restart()
                z = 1
                break
            case "forest":
                destroyable = false
                bulletPassable = tankPassable = true
                spriteRow = 3; spriteColumn = 18
                z = 10
                break
            case "ice":
                destroyable = false
                bulletPassable = tankPassable = true
                spriteRow = 3; spriteColumn = 19
                z = 1
                break


            }
        }

        BoxCollider {
            //anchors.fill: wallSprite
            width: wallSprite.width-2
            height: wallSprite.height-2
            anchors.centerIn: parent
            bodyType: Body.Static
            collisionTestingOnlyMode: tankPassable
            fixture.onBeginContact: {
                var otherEntity = other.getBody().target
                var otherEntityType = otherEntity.entityType

                if (otherEntityType === "bullet") {
                    parent.undergoBullet(otherEntity)
                }

                if (otherEntityType === "tank" && type == "ice")
                    iceSound.play()
            }
        }

        AnimatedSpriteVPlay {
            id: wallSprite
            anchors.fill: parent
            source: "../assets/img/spriteSheet16x16.png"
            frameWidth: 16
            frameHeight: 16
        }

        function undergoBullet(bullet) {
            if (!bulletPassable) {
                bullet.removeEntity()
                bulletHitWallSound.play()

            }

            if (destroyable) {
                visible = false
                explode(false)
                isDestroyed = true
                removeEntity()
            }
        }
    }
}
