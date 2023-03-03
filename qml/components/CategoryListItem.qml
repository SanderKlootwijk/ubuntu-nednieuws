import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.12

ListItem {
    width: parent.width
    height: units.gu(6)

    property string name
    property string url

    Icon {
        id: categoryIcon

        width: units.gu(3)
        height: units.gu(3)

        anchors {
            left: parent.left
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }

        source: settings.darkMode ? "../img/dark/" + categoryLabel.text + ".svg" : "../img/light/" + categoryLabel.text + ".svg"
    }

    Label {
        id: categoryLabel

        width: parent.width - units.gu(8)
        
        anchors {
            left: categoryIcon.right
            leftMargin: units.gu(2)
            verticalCenter: parent.verticalCenter
        }

        text: name
        textSize: Label.Medium
        font.weight: Font.DemiBold
        wrapMode: Text.WordWrap
    }
  
    onClicked: {
        root.categoryName = name
        feedListModel.source = url
        feedListModel.reload
        homePage.listView.contentY = 0
        pageStack.pop()
    }
}