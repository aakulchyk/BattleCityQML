import QtQuick 2.0
import VPlay 2.0

EntityBase {
    property bool destroyable: true
    property bool tankPassable: false
    property bool bulletPassable: false
    property bool removeAfterDestruction: true
    property bool isDestroyed: false

    width: 32
    height: 32

    function explode(bigExplosion) {
        var propertiesList = {
            "big": bigExplosion,
            "x": x + width/2,
            "y": y + height/2,
        }
        scene.createExplosion(propertiesList)
    }
}
