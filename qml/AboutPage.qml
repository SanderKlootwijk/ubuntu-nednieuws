import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import "components"

Page {
    id: aboutPage

    header: PageHeader {
        id: aboutPageHeader

        title: "Over"
    }

    Flickable {
        id: aboutFlickable

        anchors {
            fill: parent
            topMargin: aboutPageHeader.height
        }
        
        contentHeight: aboutCloumn.height

        Column {
            id: aboutCloumn
            
            width: parent.width
            
            spacing: units.gu(2)

            Item {
                width: parent.height
                height: units.gu(2)
            }

            LomiriShape {
                width: units.gu(15)
                height: units.gu(15)
                
                anchors.horizontalCenter: parent.horizontalCenter
                
                radius: "large"
                
                source: Image {
                    mipmap: true
                    source: "../assets/ubuntu-nednieuws.png"
                }
            }

            Item {
                width: nameAndVersionLayout.width
                height: nameAndVersionLayout.height
                
                anchors.horizontalCenter: parent.horizontalCenter

                ListItemLayout {
                    id: nameAndVersionLayout
                    
                    padding {
                        top: units.gu(0)
                        bottom: units.gu(2)
                    }

                    title.text: "NedNieuws"
                    title.font.pixelSize: units.gu(3)
                    title.color: theme.palette.normal.backgroundText
                    title.horizontalAlignment: Text.AlignHCenter

                    subtitle.text: "Versie" + " " + root.version

                    subtitle.color: theme.palette.normal.backgroundTertiaryText
                    subtitle.font.pixelSize: units.gu(1.75)
                    subtitle.horizontalAlignment: Text.AlignHCenter
                }
            }
            Column {
                width: parent.width
                Repeater {
                    id: listViewAbout
                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    model: [
                    { name: "Broncode", url: "https://github.com/sanderklootwijk/ubuntu-nednieuws" },
                    { name: "Meld problemen",  url: "https://github.com/sanderklootwijk/ubuntu-nednieuws/issues" }
                    ]

                    delegate: ListItem {
                        ListItemLayout {
                            title.text : modelData.name
                            ProgressionSlot {
                                width:units.gu(2)
                            }
                        }
                        onClicked: Qt.openUrlExternally(modelData.url)
                    }
                }
            }
        }
    }
}
