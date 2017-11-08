import QtQuick 2.0
import VPlay 2.0

BaseSpriteSequence
{
    defaultSource: "../assets/img/spriteSheet16x16.png"
    property int playerLevel: 1

    SpriteVPlay {
        name: "standUp"
        frameWidth: 16
        frameHeight: 16
        frameCount: 1
        startFrameColumn: 1
        startFrameRow: playerLevel
    }

    SpriteVPlay {
        name: "moveUp"
        frameWidth: 16
        frameHeight: 16
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 1
        startFrameRow: playerLevel
        //to: {"moveUp":0, "standUp":1}
    }

    SpriteVPlay {
        name: "standLeft"
        frameWidth: 16
        frameHeight: 16
        frameCount: 1
        startFrameColumn: 3
        startFrameRow: playerLevel
    }

    SpriteVPlay {
        name: "moveLeft"
        frameWidth: 16
        frameHeight: 16
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 3
        startFrameRow: playerLevel
        //to: {"moveLeft":0, "standLeft":1}
    }

    SpriteVPlay {
        name: "standDown"
        frameWidth: 16
        frameHeight: 16
        frameCount: 1
        startFrameColumn: 5
        startFrameRow: playerLevel
    }

    SpriteVPlay {
        name: "moveDown"
        frameWidth: 16
        frameHeight: 16
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 5
        startFrameRow: playerLevel
        //to: {"moveDown":0, "standDown":1}
    }

    SpriteVPlay {
        name: "standRight"
        frameWidth: 16
        frameHeight: 16
        frameCount: 1
        startFrameColumn: 7
        startFrameRow: playerLevel
    }

    SpriteVPlay {
        name: "moveRight"
        frameWidth: 16
        frameHeight: 16
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 7
        startFrameRow: playerLevel
        //to: {"moveRight":0, "standRight":1}
    }
}
