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
            selector.selectedIndex = settings.selectedIndex
        }

        OptionSelector {
            id: selector

            anchors.horizontalCenter: parent.horizontalCenter

            containerHeight: parent.height * 0.75
            expanded: true
            
            model: ["Klein","Normaal","Groot"]
            
            onSelectedIndexChanged: {
                switch(selector.selectedIndex) {
                    case 0: {
                        articleWebView.zoomFactor = 0.75
                        settings.zoomFactor = 0.75
                        settings.selectedIndex = 0
                        articleWebView.zoomFactor = 0.75
                        break;
                    }
                    case 1: {
                        articleWebView.zoomFactor = 1.0
                        settings.zoomFactor = 1.0
                        settings.selectedIndex = 1
                        articleWebView.zoomFactor = 1.0
                        break;
                    }
                    case 2: {
                        articleWebView.zoomFactor = 1.25
                        settings.zoomFactor = 1.25
                        settings.selectedIndex = 2
                        articleWebView.zoomFactor = 1.25
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