import VPlay 2.0
import QtQuick 2.0
import QtMultimedia 5.0

GameWindow {
    id: gameWindow
    // the size of the Window can be changed at runtime by pressing the number keys 1-7
    // the content of the logical scene size (480x320 by default) gets scaled to the window size based on the scaleMode
    screenWidth: 960
    screenHeight: 640
    color: "grey"

    // You get free licenseKeys from https://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    licenseKey: "A11F83A0434D6DF9379F58AB8977229643C8311FED03DF90B2484717E8D9A5B810AB97919FF8B685AD4F2BCF4CF0F6C360C2E2FE459A8CE7D59940142FBB87B83D08D03A8AD929DE3DA160601A79DFC218FB8590F2CEAF46CC96BD1E67703EFB40F274AC7B0360E88E3B622B2503D640020612BBEA2537A06AF6F4D434DDA57F6B7E1040D112F8C88A16B2302553817358D80DAF77664D5B5B4FEC6D3719929F9582076823D9FA3A810125DE74539A6541BE94A5CC7D167E4BE592CE7B7751E24056FF57221244A60C8E0F81D472CCC052BE87700049414182992DFF67BAFB31F2ABEF6269D6C700629236FE189287663B3E7A07542480EBFED7C08F7436FE7B71D662044DA2F890B8DC8C4B1B674E2246491D40525EB37A70B45178622DEB2CB42329EE4EBDC34CFC6ED88F70ED655C4C9BA60906197181E1F7B620A332905377AC9BBA35D240E25DABE5C5C00742F3"

    // create a licenseKey to hide the splash screen
    property bool splashFinished: false
    onSplashScreenFinished: {
        /*scene.visible = false
        titleScene.visible = true*/
        splashFinished = true

        startGameScene()
    }

    // this gets set from Monster, after it reached the player and is read by the GameOverScene to display if the player has won or lost
    property bool gameWon

    property int monstersDestroyed
    /*onMonstersDestroyedChanged: {
        if(monstersDestroyed > 20) {
            // you won the game, shot at 5 monsters
            changeToGameOverScene(true)
        }
    }*/

    // for creating entities (monsters and projectiles) at runtime dynamically
    EntityManager {
        id: entityManager
        entityContainer: scene
        //poolingEnabled: true
    }

    Rectangle {
        id: vgamepad
        visible: scene.visible
        width: 200
        height: width*3
        anchors.top: parent.verticalCenter
        anchors.leftMargin: scene.borderWidth
        color: "grey"

        ControlButton {
            id: upButton
            x: width/2; y:0
            action: "moveUp"
        }
        ControlButton {
            id: leftButton
            anchors.top: upButton.bottom
            anchors.left: parent.left
            action: "moveLeft"
        }
        ControlButton {
            id: rightButton
            anchors.top: upButton.bottom
            anchors.left: leftButton.right
            action: "moveRight"
        }
        ControlButton {
            id: downButton
            anchors.top: leftButton.bottom
            anchors.horizontalCenter: leftButton.right
            action: "moveDown"
        }
    }

    ControlButton {
        id: fireButton
        visible: scene.visible
        width: 100; height: 100

        color: "red"
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.rightMargin: scene.borderWidth
        anchors.bottomMargin: height

        action: "fire"
    }



    // switch to this scene, after the game was lost or won and it switches back to the gameScene after 3 seconds
    Scene {
        id: titleScene
        visible: false

        Image
        {
            anchors.fill: parent
            source: "../assets/img/front.jpg"
        }

        ButtonVPlay
        {
            anchors.centerIn: parent
            text: "Start the Game"

            onClicked: startGameScene()
        }

        BackgroundMusic {
            id: titleMusic
            source: "../assets/snd/Battle_City-Main_theme_(Metal_cover).mp3" // will start playing automatically after loading
        }

        BackgroundMusic {
            id: gameOverMusic
            autoPlay: false
            loops: 1
            source: "../assets/snd/game_over.mp3"
        }
    }// GameOverScene

    Scene {
        id: scene

        property int borderWidth : 4
        property int borderHeight : 4

        property int tilesX: 15
        property int tilesY: 10

        gridSize: 32

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: gridSize*tilesX + borderWidth*2
        height: gridSize*tilesY + borderHeight*2

        anchors.left: vgamepad.right

        backButtonAutoAccept: true

        property alias player: player

        Rectangle {
            anchors.fill: parent
            color: "black"
            z: -1
        }

        // components
        Player {id: player; x: xByPos(5); y: yByPos(9)}

        Enemy {id: enemy}
        Bonus {id: bonus}
        Wall {id: wall}
        Eagle {id: eagle}

        Border {x:0; y:0; width: scene.width; height: scene.borderHeight}
        Border {x:0; y:scene.borderHeight; width: scene.borderWidth; height: scene.height-scene.borderHeight*2}
        Border {x:0; y:scene.height-scene.borderHeight; width: scene.width; height: scene.borderHeight}
        Border {x:scene.width-scene.borderWidth; y:scene.borderHeight; width: scene.borderWidth; height: scene.height-scene.borderHeight*2}

        Keys.forwardTo: player ? player.controller : null

        SoundEffectVPlay {
            id: bulletCreationSound
            source: "../assets/snd/shot.wav" // gets played when a projectile is created below
        }

        SoundEffectVPlay {
            id: tankStandingSound
            loops: SoundEffect.Infinite
            source: "../assets/snd/tankStanding.wav"
        }

        SoundEffectVPlay {
            id: tankMovingSound
            loops: SoundEffect.Infinite
            muted: true
            source: "../assets/snd/tankMoving.wav"
        }

        SoundEffectVPlay {
            id: bulletHitMetalSound
            loops: 1
            source: "../assets/snd/Battle City SFX (2).wav"
        }

        SoundEffectVPlay {
            id: bulletHitWallSound
            loops: 1
            source: "../assets/snd/Battle City SFX (3).wav"
        }

        SoundEffectVPlay {
            id: objectDestroyedSound
            loops: 1
            source: "../assets/snd/smallExplosion.wav"
        }

        SoundEffectVPlay {
            id: eagleDestroyedSound
            loops: 1
            source: "../assets/snd/bigExplosion.wav"
        }

        SoundEffectVPlay {
            id: iceSound
            loops: 1
            source: "../assets/snd/ice.wav"
        }

        SoundEffectVPlay {
            id: bonusSound
            loops: 1
            source: "../assets/snd/bonus.wav"
        }

        PhysicsWorld {
            //debugDrawVisible: true
        } // put it anywhere in the Scene, so the collision detection between monsters and projectiles can be done


        function startGameOverTimer() {
            tankStandingSound.stop()
            gameOverTimer.start()
        }

        Timer {
            id: gameOverTimer
            interval: 5000
            onTriggered: changeToGameOverScene(false)
        }

        Explosion {id: explosion}

        function createExplosion(propertiesList) {
            entityManager.createEntityFromComponentWithProperties(explosion, propertiesList)
        }
    }


    function xByPos(posX) {
        return scene.borderWidth  +  posX * scene.gridSize
    }

    function yByPos(posY) {
        return scene.borderHeight  +  posY * scene.gridSize
    }

    function addTarget() {
        var pos = Math.floor(Math.random()*scene.tilesX)
        entityManager.createEntityFromComponentWithProperties(enemy, {"x": xByPos(pos), "y": yByPos(0)})
    }

    function addBonus() {
        var types = ["helmet", "clock", "shovel", "star", "grenade", "tank", "gun"]
        var typeI = Math.floor(Math.random()*types.length)
        var posX = Math.floor(Math.random()*scene.tilesX)
        var posY = Math.floor(Math.random()*scene.tilesY)
        var propertiesList = {
            "type": types[typeI],
            "x": xByPos(posX),
            "y": yByPos(posY)
        }
        entityManager.createEntityFromComponentWithProperties(bonus, propertiesList)
    }

    onSplashFinishedChanged: {
        if (splashFinished === false)
            return

        console.log("INIT SCENE!")
        entityManager.createEntityFromComponentWithProperties(eagle, {"x": xByPos(7), "y": yByPos(9)})

        entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(6), "y": yByPos(9)})
        entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(8), "y": yByPos(9)})
        entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(6), "y": yByPos(8)})
        entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(7), "y": yByPos(8)})
        entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(8), "y": yByPos(8)})

        // brick walls
        for (var i = 0; i < scene.tilesX; i++)
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "brick", "x": xByPos(i), "y": yByPos(1)})

        for (i = 0; i < 2; i++) {
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "concrete", "x": xByPos(i), "y": yByPos(3)})
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "concrete", "x": xByPos(scene.tilesX-1-i), "y": yByPos(3)})
        }

        for (i = 2; i < scene.tilesX-2; i++)
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "forest", "x": xByPos(i), "y": yByPos(3)})

        for (i = 6; i < scene.tilesX-6; i++) {
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "water", "x": xByPos(i), "y": yByPos(5)})
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "water", "x": xByPos(i), "y": yByPos(5)})
        }

        // ice river
        for (var i = 0; i < scene.tilesX; i++)
            entityManager.createEntityFromComponentWithProperties(wall, {"type": "ice", "x": xByPos(i), "y": yByPos(7)})
    }

    Scene {
        id: gameOverScene
        visible: false

        Rectangle {
            anchors.fill: parent
            color: "black"
            Text {
                id: gameOverText
                anchors.centerIn: parent
                color: "white"
                text: "GAME OVER"
            }

            Text {
                color: "white"
                anchors.top: gameOverText.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Enemies destroyed: " + monstersDestroyed
            }
        }


    }


    Timer {
        running: scene.visible == true && splashFinished // only enable the creation timer, when the gameScene is visible
        repeat: true
        interval: 5000 // a new target(=monster) is spawned every second
        onTriggered: {
            var r = Math.floor(Math.random()*4)
            if (r<3)
                addTarget()
            else
                addBonus()
        }
    }

    function startGameScene() {
        gameOverScene.visible = false
        titleScene.visible = false
        scene.visible = true;
        titleMusic.stop()
        tankStandingSound.play()
        tankMovingSound.play()
    }

    function changeToGameOverScene(won) {
        // reset the game variables and remove all projectiles and monsters
        scene.visible = false
        gameWon = won
        gameOverScene.visible = true
        gameOverMusic.play()
        entityManager.removeEntitiesByFilter(["wall", "eagle", "tank", "bullet", "explosion"])


    }
}
//![0]
