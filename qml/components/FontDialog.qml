import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3

Component {
    Dialog {
        id: dialog
        
        title: "Weergave"

        signal closed()

        Component.onCompleted: {
            zoomSelector.selectedIndex = settings.selectedZoomIndex
            fontSelector.selectedIndex = settings.selectedFontIndex
        }

        Label {
            text: "Tekstgrootte:"

            color: theme.palette.normal.backgroundSecondaryText
            elide: Text.ElideRight
            font.bold: true
        }

        OptionSelector {
            id: zoomSelector

            anchors.horizontalCenter: parent.horizontalCenter

            containerHeight: parent.height * 0.75
            expanded: false
            
            model: ["Klein","Normaal","Groot"]
            
            onSelectedIndexChanged: {
                switch(zoomSelector.selectedIndex) {
                    case 0: {
                        settings.zoomFactor = 0.75
                        settings.selectedIndex = 0
                        break;
                    }
                    case 1: {
                        settings.zoomFactor = 1.0
                        settings.selectedIndex = 1
                        break;
                    }
                    case 2: {
                        settings.zoomFactor = 1.25
                        settings.selectedIndex = 2
                        break;
                    }
                }
            }
        }

        Label {
            text: "Lettertype:"

            color: theme.palette.normal.backgroundSecondaryText
            elide: Text.ElideRight
            font.bold: true
        }

        OptionSelector {
            id: fontSelector

            anchors.horizontalCenter: parent.horizontalCenter

            containerHeight: parent.height * 0.75
            expanded: false
            
            model: ["Ubuntu","NOS standaard"]
            
            onSelectedIndexChanged: {
                switch(fontSelector.selectedIndex) {
                    case 0: {
                        settings.fontType = "Ubuntu"
                        settings.selectedFontIndex = 0
                        break;
                    }
                    case 1: {
                        settings.fontType = "nosdefault"
                        settings.selectedFontIndex = 1
                        break;
                    }
                }
            }
        }

        Button {
            width: parent.width
            
            color: theme.palette.normal.activity
            text: "Sluiten"

            onClicked: {
                PopupUtils.close(dialog)
                closed()
            }
        }
    }
}