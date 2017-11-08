import QtQuick 2.0
import VPlay 2.0
Component {
    Tank {

        width: 28
        height: 28

        EnemySpriteAnimation {
            width: parent.width
            height: parent.height
            anchors.centerIn: parent

            id: sprites
        }

        Timer {
            id: t;
            running: true
            repeat: true;
            interval: 1000;
            onTriggered: randomAction();
        }

        onIsDestroyedChanged: gameWindow.monstersDestroyed++

        function randomAction() {
            var rnd = Math.floor(Math.random()*5)

            //console.log("Enemy: action " + rnd)

            if (rnd === 4) {
                stopMoving()
                fire()
            }
            else
                move(rnd)
            //if (Math.abs(x-player.x) < width/2)
             //   ;
        }
    }
}
