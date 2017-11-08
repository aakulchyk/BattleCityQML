import QtQuick 2.0
import VPlay 2.0
BasicObject {
    id: border
    entityType: "border"
    destroyable: false
    bulletPassable: false
    tankPassable: false

    BoxCollider {
        anchors.fill: parent
        bodyType: Body.Static

        fixture.onContactChanged: {
            var otherEntity = other.getBody().target
            var otherEntityType = otherEntity.entityType

            if (otherEntityType === "bullet") {
                otherEntity.removeEntity()
                bulletHitWallSound.play()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "gray"
    }
}
