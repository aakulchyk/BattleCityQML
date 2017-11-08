import QtQuick 2.0
import VPlay 2.0

BasicObject {
//EntityBase {
    entityType: "tank" // required for removing all of these entities when the game is lost

    property bool isPlayer: false
    property bool moving: false
    property int direction: 1 // 0-left, 1-up, 2-right, 3-down
    property int speed: 50
    property int hp: 1
    property string stringId: generateStringId()
    property int bulletsFired: 0
    property int maxBullets: 1

    property alias collider: collider
    property alias horizontalVelocity: collider.linearVelocity.x
    property alias verticalVelocity: collider.linearVelocity.y

    property int xAxis: 0
    property int yAxis: 0

    z: 2

    onXAxisChanged: horizontalVelocity = xAxis * speed;
    onYAxisChanged: verticalVelocity = yAxis * speed;

    BoxCollider {
        id: collider
        bodyType: Body.Dynamic
        //anchors.fill: parent
        width: sprites.width-2
        height: sprites.height-2
        anchors.centerIn: parent

        fixture.onBeginContact: {
            var otherEntity = other.getBody().target
            var otherEntityType = otherEntity.entityType

            // if another tank running to us and we are not moving
            if (otherEntityType === "tank" && moving === false)
                horizontalVelocity = verticalVelocity = 0; // prevent from slipping

            //console.log("collide: " + otherEntityType + " + " + parent.entityType + "(this)")

            if (otherEntityType === "bullet" && otherEntity.ownerId != parent.stringId) {
                otherEntity.removeEntity()
                hp--
                if (hp<=0) {

                    isDestroyed = true
                    parent.visible = false
                    if (isPlayer) {
                        explode(true)
                        eagleDestroyedSound.play()
                    }
                    else
                    {
                        explode(false)
                        objectDestroyedSound.play()
                        removeEntity()
                    }
                }
                else
                    bulletHitMetalSound.play()
            }
        }
    }

    Bullet {id: bullet}

    function move(dir) {
        var actionName = "undefined"
        switch (dir) {
        case 0: xAxis = -1; yAxis = 0; actionName = "moveLeft"; break
        case 1: yAxis = -1; xAxis = 0; actionName = "moveUp"; break
        case 2: xAxis =  1; yAxis = 0; actionName = "moveRight"; break
        case 3: yAxis =  1; xAxis = 0; actionName = "moveDown"; break
        default:
            console.error("Invalid direction!")
            return;
        }

        moving = true
        direction = dir
        sprites.jumpTo(actionName)
    }

    function stopMoving() {
        moving = false
        xAxis = yAxis = 0
        switch (sprites.currentSprite)
        {
            case "moveUp": sprites.jumpTo("standUp"); break;
            case "moveDown": sprites.jumpTo("standDown"); break;
            case "moveLeft": sprites.jumpTo("standLeft"); break;
            case "moveRight": sprites.jumpTo("standRight"); break;
        }
    }

    function fire() {
        var bulletOffset = 12//width/2 - bullet.width/2
        console.log("fire:" + width + " " + height + " " + bullet.width + " " + bullet.height)
        var sourceX = x + ((direction==1 || direction==3) ? bulletOffset : (direction==0) ? 0 : 32)
        var sourceY = y + ((direction==0 || direction==2) ? bulletOffset : (direction==1) ? 0 : 32)

        var source = Qt.point(Math.round(sourceX), Math.round(sourceY))

        var targetX = (direction==1 || direction==3) ? source.x : (direction==0) ? 0 : scene.width
        var targetY = (direction==0 || direction==2) ? source.y : (direction==1) ? 0 : scene.height
        var target = Qt.point(Math.round(targetX), Math.round(targetY))
        var length = Math.abs(targetX-x + targetY-y)
        var velocity = 120
        var realMoveDuration = Math.round(length / velocity * 1000)

        var propertiesList = {
            "ownerId": stringId,
            "x": sourceX, "y": sourceY,
            "source": source, "destination": target,
            "moveDuration": realMoveDuration
        }
        /*var entityId = */entityManager.createEntityFromComponentWithProperties(bullet, propertiesList)
        //var bulletEntity = entityManager.getEntityById(entityId)

        bulletCreationSound.play()
    }

    function generateStringId()
    {
        var text = " ";

        var charset = "abcdefghijklmnopqrstuvwxyz0123456789";

        for( var i=0; i < 8; i++ )
            text += charset.charAt(Math.floor(Math.random() * charset.length));

        return text;
    }

}
