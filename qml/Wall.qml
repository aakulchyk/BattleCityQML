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

        property bool lt: true
        property bool rt: true
        property bool lb: true
        property bool rb: true

        property bool bulletWasVertical

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
                spriteRow = 4; spriteColumn = 17
                wallSprite.frameCount = 2
                wallSprite.frameRate = 1
                wallSprite.running = true
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

        onLtChanged: sidesChanged()
        onRtChanged: sidesChanged()
        onLbChanged: sidesChanged()
        onRbChanged: sidesChanged()

        function sidesChanged() {
            if (type != "brick") return

            console.log("SIDES CHANGED!")

            var cnt = 0;
            if (lt) cnt++
            if (rt) cnt++
            if (lb) cnt++
            if (rb) cnt++

            if (cnt == 3) {
                var v = bulletWasVertical

                if (!lt)
                    if (v) rt = false; else lb = false
                else if (!rt)
                    if (v) lt = false; else rb = false
                else if (!lb)
                    if (v) rb = false; else lt = false
                else if (!rb)
                    if (v) lb = false; else rt = false

                cnt = 2
            }

            if (cnt == 2) {
                if (lt && rt && !lb && !rb)
                    spriteColumn = 21; // top

                if (!lt && !rt && lb && rb)
                    spriteColumn = 19; // bottom

                if (lt && !rt && lb && !rb)
                    spriteColumn = 20; // left

                if (!lt && rt && !lb && rb)
                    spriteColumn = 18; // bottom
            }
            if (cnt == 1) {
                wallSprite.anchors.fill = undefined
                wallSprite.frameWidth = wallSprite.frameHeight = 8
                wallSprite.frameX = 256; wallSprite.frameY = 64
                wallSprite.width = width/2; wallSprite.height = height/2
                if (lt) {
                    wallSprite.anchors.left = left
                    wallSprite.anchors.top = top
                }
                if (rt) {
                    wallSprite.anchors.right = right
                    wallSprite.anchors.top = top
                }
                if (lb) {
                    wallSprite.anchors.left = left
                    wallSprite.anchors.bottom = bottom
                }
                if (rb) {
                    wallSprite.anchors.right = right
                    wallSprite.anchors.bottom = bottom
                }
            }

            if (cnt==0)
                destroyFully()

            wallSprite.restart()
        }

        AnimatedSpriteVPlay {
            id: wallSprite
            anchors.fill: parent
            source: "../assets/img/spriteSheet16x16.png"
            frameWidth: 16
            frameHeight: 16
        }

        BoxCollider {
            id: ltCollider
            width: (wallSprite.width)/2
            height: (wallSprite.width)/2
            anchors.left: parent.left
            anchors.top: parent.top
            bodyType: Body.Static
            collisionTestingOnlyMode: tankPassable
            active: parent.lt
            fixture.onBeginContact: collide('lt', other)
        }
        BoxCollider {
            id: rtCollider
            width: (wallSprite.width)/2
            height: (wallSprite.width)/2
            anchors.right: parent.right
            anchors.top: parent.top
            bodyType: Body.Static
            collisionTestingOnlyMode: tankPassable
            active: parent.rt
            fixture.onBeginContact: collide('rt', other)
        }
        BoxCollider {
            id: lbCollider
            width: (wallSprite.width)/2
            height: (wallSprite.width)/2
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            bodyType: Body.Static
            collisionTestingOnlyMode: tankPassable
            active: parent.lb
            fixture.onBeginContact: collide('lb', other)
        }
        BoxCollider {
            id: rbCollider
            width: (wallSprite.width)/2
            height: (wallSprite.width)/2
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            bodyType: Body.Static
            collisionTestingOnlyMode: tankPassable
            active: parent.rb
            fixture.onBeginContact:  collide('rb', other)
        }


        function collide(side, other) {
            var s = false
            switch (side) {
                case 'lt': s = lt; break
                case 'rt': s = rt; break
                case 'lb': s = lb; break
                case 'rb': s = rb; break
            }
            if (!s) return

            var otherEntity = other.getBody().target
            var otherEntityType = otherEntity.entityType

            if (otherEntityType === "bullet") {
                bulletWasVertical = otherEntity.vertical
                undergoBullet(side, otherEntity)
            }

            if (otherEntityType === "tank" && type == "ice")
                iceSound.play()
        }

        function undergoBullet(side, bullet) {
            if (!bulletPassable) {
                bullet.removeEntity()
                bulletHitWallSound.play()

            }

            if (destroyable) {
                switch (side) {
                    case 'lt': lt = false; break
                    case 'rt': rt = false; break
                    case 'lb': lb = false; break
                    case 'rb': rb = false; break
                }
            }
        }

        function destroyFully() {
            visible = false
            explode(false)
            isDestroyed = true
            removeEntity()
        }
    }
}
