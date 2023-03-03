import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

ListItem {
    height: units.gu(12)

    // Put contents in a 'box'
    Item {
        anchors {
            centerIn: parent
        }

        // Adjust width on big screens (e.g. tablets or extended display), Ubuntu Touch's convergence feature
        height: parent.height - units.gu(2)
        width: root.width > units.gu(85) ? units.gu(81) : parent.width - units.gu(4)

        Rectangle {
            id: imagePlaceholder

            anchors.fill: articleImage

            visible: articleImage.status == Image.Ready ? false : true

            color: "#7f7f7f"

            Icon {
                width: units.gu(3)
                height: width

                anchors.centerIn: parent

                name: "stock_image"
                color: "#cdcdcd"
            }
        }

        Image {
            id: articleImage

            width: parent.height * 1.33
            height: parent.height

            anchors {
                top: parent.top
                left: parent.left
            }

            source: image
            fillMode: Image.PreserveAspectCrop
        }

        Label {
            id: articleTitle

            width: parent.width - articleImage.width - units.gu(2)
            
            anchors {
                left: articleImage.right
                leftMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }

            text: title
            textSize: Label.Medium
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
        }
    }

    onClicked: {
        // hide webview from user
        articlePage.articleWebView.opacity = 0

        // stop webview, clear it's history and add new url to article
        articlePage.articleWebView.stop()
        articlePage.articleWebView.navigationHistory.clear()
        articlePage.articleWebView.url = link

        // push articlePage
        pageStack.push(articlePage)
    }
}