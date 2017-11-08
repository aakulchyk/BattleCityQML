import QtQuick 2.0
import VPlay 2.0

BaseSpriteSequence
{
    defaultSource: "../assets/img/enemies.png"
    property int type: 0

    SpriteVPlay {
        name: "standUp"
        frameWidth: 28
        frameHeight: 28
        frameCount: 1
        startFrameColumn: 1
        startFrameRow: 1
    }

    SpriteVPlay {
        name: "moveUp"
        frameWidth: 28
        frameHeight: 28
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 1
        startFrameRow: 1
    }

    SpriteVPlay {
        name: "standLeft"
        frameWidth: 28
        frameHeight: 28
        frameCount: 1
        startFrameColumn: 1
        startFrameRow: 4
    }

    SpriteVPlay {
        name: "moveLeft"
        frameWidth: 28
        frameHeight: 28
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 1
        startFrameRow: 4
    }

    SpriteVPlay {
        name: "standDown"
        frameWidth: 28
        frameHeight: 28
        frameCount: 1
        startFrameColumn: 1
        startFrameRow: 3
    }

    SpriteVPlay {
        name: "moveDown"
        frameWidth: 28
        frameHeight: 28
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 1
        startFrameRow: 3
    }


    SpriteVPlay {
        name: "standRight"
        frameWidth: 28
        frameHeight: 28
        frameCount: 1
        startFrameColumn: 1
        startFrameRow: 2
    }

    SpriteVPlay {
        name: "moveRight"
        frameWidth: 28
        frameHeight: 28
        frameCount: 2
        frameRate: parent.rate
        startFrameColumn: 1
        startFrameRow: 2
    }
}
