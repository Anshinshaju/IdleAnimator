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

            model: 180

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

        function generateBolt()
        {
            

            //--------------------------------------------------
            // Weighted Lightning Length
            //--------------------------------------------------

            var r = Math.random()

            var segments

            if (r < 0.10)
            {
                // Small strike (10%)
                segments = 8 + Math.floor(Math.random() * 3)
            }
            else if (r < 0.30)
            {
                // Medium strike (20%)
                segments = 11 + Math.floor(Math.random() * 4)
            }
            else if (r < 0.75)
            {
                // Large strike (45%)
                segments = 15 + Math.floor(Math.random() * 6)
            }
            else
            {
                // Massive strike (25%)
                segments = 21 + Math.floor(Math.random() * 5)
            }

            

            var startIndex = activeSegments

            activeSegments += segments

            var x = width * (0.2 + Math.random() * 0.6)
            var y = -60

            var angle = 0

            for(var i = 0; i < segments; i++)
            {
                var item = boltRepeater.itemAt(startIndex + i)

                if(item === null)
                    continue

                // ---------- Thickness ----------
                var progress = i / segments

                item.width = Math.max(1.5, 5 - progress * 3.5)

                // ---------- Length ----------
                var length = 45 + Math.random() * 35

                item.height = length

                // ---------- Small random turn ----------
                angle += (Math.random() - 0.5) * 20

                if(angle > 30)
                    angle = 30

                if(angle < -30)
                    angle = -30

                item.rotation = angle

                item.x = x
                item.y = y

                // ---------- Advance ----------
                x += Math.sin(angle * Math.PI / 180.0) * length
                y += Math.cos(angle * Math.PI / 180.0) * length

                // Keep inside screen
                if(x < 20)
                    x = 20

                if(x > width - 20)
                    x = width - 20

                if(y > height)
                    break
            }

            hideLightning.restart()
        }
        function generateStorm()
        {
            var r = Math.random()

            var boltCount

            if (r < 0.40)
                boltCount = 1
            else if (r < 0.85)
                boltCount = 2
            else if (r < 0.95)
                boltCount = 3
            else
                boltCount = 4

            for (var i = 0; i < boltCount; i++)
            {
                generateBolt()
            }
        }
    }
    
    
}