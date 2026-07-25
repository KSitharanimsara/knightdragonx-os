import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import "components"

Item {
    id: root

    height: Screen.height
    width: Screen.width
    
    Image {
        id: background
        
        anchors.fill: parent
        height: parent.height
        width: parent.width
        fillMode: Image.PreserveAspectCrop

        source: config.Background

        asynchronous: false
        cache: true
        mipmap: true
        clip: true
    }

    Item {
        id: contentPanel

        anchors {
            fill: parent
            topMargin: config.Padding
            rightMargin: config.Padding
            bottomMargin:config.Padding
            leftMargin: config.Padding
        }

        DateTimePanel {
            id: dateTimePanel

            anchors {
                top: parent.top
                right: parent.right
            }
        }
        
        LoginPanel {
            id: loginPanel
            
            anchors.fill: parent
        }
    }

    Image {
        id: brandLogo
        source: "kdx_logo.jpg"
        anchors {
            top: parent.top
            horizontalCenter: parent.horizontalCenter
            topMargin: config.Padding + 20
        }
        width: Math.min(Screen.width * 0.25, 320)
        height: width
        fillMode: Image.PreserveAspectFit
        asynchronous: false
        cache: true
        mipmap: true
    }
}
