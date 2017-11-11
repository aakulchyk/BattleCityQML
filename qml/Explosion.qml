import QtQuick 2.0
import VPlay 2.0

Component {
    EntityBase {
        entityType: "explosion"
        id: explosion
        //width: scene.gridSize*2
        //height: scene.gridSize*2

        poolingEnabled: false
        property bool big: false
        property int phase: 0

        SpriteSequenceVPlay {
            id: explosionAnimation
            anchors.centerIn: parent
            defaultSource: "../assets/img/explosion.png"
            width: scene.gridSize*2
            height: scene.gridSize*2
            z: 10
            property int rate: 15
            property alias smallExplFrames: smallExplosionSprite.frameCount
            property alias bigExplFrames: bigExplosionSprite.frameCount

            SpriteVPlay {
                id: smallExplosionSprite
                name: "smallExplosion"
                frameWidth: 32
                frameHeight: 32
                frameCount: 3
                frameRate: parent.rate
                startFrameColumn: 1
            }

            SpriteVPlay {
                id: bigExplosionSprite
                name: "bigExplosion"
                frameWidth: 32
                frameHeight: 32
                frameCount: 2
                frameRate: parent.rate
                startFrameColumn: 4
            }
        }

        Component.onCompleted: boom()

        Timer {
            id: timer;
            repeat: false
            onTriggered: removeEntity()
        }

        function timerTriggered() {
            console.log("triggered")
            if (big && phase == 0) {
                phase++
                boom()
            }
            else {
                console.log("explosion finished")
                explosion.removeEntity()
            }
        }

        function boom() {
            var timeout = 0

            var frameRate = explosionAnimation.rate
            timeout = 1000/frameRate * explosionAnimation.smallExplFrames
            if (big) {
                timeout += 1000/frameRate * explosionAnimation.bigExplFrames
                smallExplosionSprite.to = {"smallExplosion":0, "bigExplosion":1}
            }

            timer.interval = timeout;
            explosionAnimation.jumpTo("smallExplosion")
            timer.start();
        }
    }
}
