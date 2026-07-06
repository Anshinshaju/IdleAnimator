import QtQuick
import QtQuick.Window

Window {
    id: root

    visible: true
    visibility: Window.FullScreen
    color: "black"

    //==================================================
    // CONFIG
    //==================================================

    
    property bool fadingOut: false
    //==================================================
    // THUNDER SYSTEM
    //==================================================

    property int secondsSinceThunder: 0
    

    //==================================================
    // FUNCTIONS
    //==================================================

    function playThunder()
    {
        lightningLayer.generateStorm()

        igo.scale = 1.04
        igo.opacity = 1.0

        glow.opacity = 0.9

        logoReset.restart()
    }
    
    //==================================================
    // TIMERS
    //==================================================

    Timer {
        id: thunderTimer

        interval: 1000
        repeat: true
        running: true

        onTriggered: {

            secondsSinceThunder++

            var chance

            if(secondsSinceThunder >= 8)
                chance = 100
            else
                chance = 5 + (secondsSinceThunder - 1) * (95 / 7)

            if(Math.random() * 100 < chance)
            {
                

                playThunder()

                secondsSinceThunder = 0
            }
        }
    }

    Timer {
        id: flashReset

        interval: 100

        onTriggered: {
            lightningFlash.opacity = 0.0
        }
    }

    Timer {
        id: logoReset

        interval: 180

        onTriggered: {

            igo.scale = 1.0
            igo.opacity = 0.9

            glow.opacity = 0.35
        }
    }
    
    //==================================================
    // STARTUP
    //==================================================

    Component.onCompleted: {

        console.log("Sleep.qml Started")
    }

    //==================================================
    // VISUALS
    //==================================================

    //--------------------------------------------------
    // Background
    //--------------------------------------------------

    Image {
        id: background

        anchors.fill: parent

        source: "../assets/back1.png"

        fillMode: Image.PreserveAspectCrop

        smooth: true
        mipmap: true
        asynchronous: true
    }

    //--------------------------------------------------
    // Darkness Overlay
    //--------------------------------------------------

    Rectangle {
        id: darkness

        anchors.fill: parent

        color: "#55000000"
    }

    //--------------------------------------------------
    // Rain Behind
    //--------------------------------------------------

    Item {

        id: rainBack

        anchors.fill: parent

        Repeater {

            model: 80

            Rectangle {

                width: 2
                height: 12 + Math.random() * 18

                color: "#AAEAF6FF"

                opacity: 0.7

                x: Math.random() * rainBack.width
                y: -2000 + Math.random() * (rainBack.height + 2000)

                rotation: 12

                NumberAnimation on y {

                    from: -50
                    to: rainBack.height + 50

                    duration: 600 + Math.random() * 600

                    loops: Animation.Infinite

                    running: true
                }
            }
        }
    }

    //--------------------------------------------------
    // Glow
    //--------------------------------------------------

    Rectangle {

        id: glow

        width: igo.width + 120
        height: igo.height + 120

        anchors.centerIn: igo

        radius: width / 2

        color: "#18FFFFFF"

        opacity: 0.35

        SequentialAnimation on opacity {

            loops: Animation.Infinite

            NumberAnimation {
                to: 0.55
                duration: 2000
            }

            NumberAnimation {
                to: 0.30
                duration: 2000
            }
        }
    }

    //--------------------------------------------------
    // IGO Logo
    //--------------------------------------------------

    Text {

        id: igo

        anchors.centerIn: parent

        text: "IGO"

        font.family: "Segoe UI"
        font.pixelSize: 240
        font.bold: true

        color: "#AAFFFFFF"

        style: Text.Outline
        styleColor: "#55FFFFFF"

        opacity: 0.9

        layer.enabled: true

        SequentialAnimation on scale {

            loops: Animation.Infinite

            NumberAnimation {
                to: 1.015
                duration: 2500
            }

            NumberAnimation {
                to: 1.0
                duration: 2500
            }
        }

        SequentialAnimation on opacity {

            loops: Animation.Infinite

            NumberAnimation {
                to: 0.96
                duration: 1800
            }

            NumberAnimation {
                to: 0.90
                duration: 1800
            }
        }
    }
        //--------------------------------------------------
    // Rain Front
    //--------------------------------------------------

    Item {

        id: rainFront

        anchors.fill: parent

        Repeater {

            model: 50

            Rectangle {

                width: 3
                height: 18 + Math.random() * 22

                color: "#EEFFFFFF"

                opacity: 0.9

                x: Math.random() * rainFront.width
                y: -2000 + Math.random() * (rainFront.height + 2000)

                rotation: 14

                NumberAnimation on y {

                    from: -60
                    to: rainFront.height + 60

                    duration: 350 + Math.random() * 300

                    loops: Animation.Infinite

                    running: true
                }
            }
        }
    }

    //--------------------------------------------------
    // Lightning Overlay
    //--------------------------------------------------

    Item {
        id: lightningLayer

        anchors.fill: parent

        z: 1000

        property int activeSegments: 0

        Repeater {

            id: boltRepeater

            model: 60

            Rectangle {

                id: segment

                width: 4
                height: 50

                radius: 2

                color: "white"

                visible: index < lightningLayer.activeSegments

                x: 0
                y: 0

                rotation: 0

                opacity: 1.0
            }
        }

        Timer {

            id: hideLightning

            interval: 120

            onTriggered: {

                lightningLayer.activeSegments = 0
            }
        }

        function generateStorm()
        {
            activeSegments = 0

            var segments = 10 + Math.floor(Math.random()*16)

            activeSegments = segments

            var x = Math.random()*width

            var y = -80

            for(var i=0;i<segments;i++)
            {
                var item = boltRepeater.itemAt(i)

                if(item===null)
                    continue

                var length = 40 + Math.random()*50

                var angle = -30 + Math.random()*60

                item.width = 4
                item.height = length

                item.rotation = angle

                item.x = x
                item.y = y

                x += Math.sin(angle*Math.PI/180)*length
                y += Math.cos(angle*Math.PI/180)*length

                if(x<0)
                    x=0

                if(x>width)
                    x=width
            }

            hideLightning.restart()
        }
    }
    
    
}