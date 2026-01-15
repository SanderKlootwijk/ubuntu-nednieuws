import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Connectivity 1.0
import QtQuick.Layouts 1.3
import QtQuick.XmlListModel 2.0
import "components"

Page {
    id: homePage

    property alias listView: listView

    header: PageHeader {
        id: homePageHeader

        height: units.gu(8)
        
        title: "NedNieuws"
        subtitle: root.categoryName

        trailingActionBar {
            numberOfSlots: 2

            actions: [
                Action {
                    text: "Instellingen"
                    iconName: "settings"
                    onTriggered: pageStack.push(settingsPage)
                },
                Action {
                    text: "Categorieën"
                    iconName: "tag"
                    onTriggered: pageStack.push(categoryPage)
                }
            ]
        }
    }

    Connections {
        target: Connectivity
        
        onStatusChanged: {
            if (Connectivity.status == NetworkingStatus.Online) {
                //pullToRefresh.refresh()
                listView.model.reload()
                listview.forceLayout()
            }
        }
    }

    Item {
        id: offlineItem

        width: parent.width
        height: units.gu(30)

        anchors {
            top: homePageHeader.bottom
            horizontalCenter: parent.horizontalCenter
        }

        visible: Connectivity.status == NetworkingStatus.Offline ? true : false

        Icon {
            id: offlineIcon
            
            width: units.gu(3.5)
            height: units.gu(3.5)

            anchors.centerIn: parent

            name: "nm-signal-00"
            color: offlineLabel.color
        }

        Label {
            id: offlineLabel

            anchors {
                top: offlineIcon.bottom
                topMargin: units.gu(1.5)
                horizontalCenter: parent.horizontalCenter
            }

            text: "Je bent momenteel offline"
        }
    }

    ListView {
        id: listView

        anchors {
            fill: parent
            topMargin: homePageHeader.height
        }

        visible: Connectivity.status == NetworkingStatus.Offline ? false : true

        model: feedListModel
        delegate: ArticleListItem {}

        // PullToRefresh {
        //     id: pullToRefresh
        //     enabled: Connectivity.status == NetworkingStatus.Offline ? false : true
        //     refreshing: listView.model.status === XmlListModel.Loading
        //     onRefresh: {
        //         listView.model.reload()
        //         listview.forceLayout()
        //     }
        // }

        Scrollbar {
            flickableItem: listView
            align: Qt.AlignTrailing
        }
    }
}
