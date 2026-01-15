import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

Page {
    id: settingsPage

    header: PageHeader {
        id: settingsPageHeader

        title: "Settings"
    }

    Flickable {
        id: settingsFlickable

        anchors {
            fill: parent
            topMargin: settingsPageHeader.height
        }

        contentWidth: settingsColumn.width
        contentHeight: settingsColumn.height

        Column {
            id: settingsColumn

            width: settingsPage.width

            ListItem {
                id: themeTitle

                height: units.gu(6.25)

                divider.colorFrom: theme.palette.normal.background
                divider.colorTo: theme.palette.normal.background

                Label {
                    id: themeTitleLabel

                    width: parent.width - units.gu(4)

                    anchors {
                        bottom: parent.bottom
                        bottomMargin: units.gu(1.25)
                        left: parent.left
                        leftMargin: units.gu(2)
                    }

                    text: "Thema:"

                    color: theme.palette.normal.backgroundSecondaryText
                    elide: Text.ElideRight
                    font.bold: true
                }
            }

            ListItem {
                id: themeListItem

                height: themeOptionSelector.height + units.gu(2)

                OptionSelector {
                    id: themeOptionSelector

                    width: parent.width - units.gu(4)

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                    }

                    model: ["Systeem", "Ambiance", "Suru Dark"]

                    onSelectedIndexChanged: settings.theme = selectedIndex

                    Component.onCompleted: selectedIndex = settings.theme
                }
            }

            ListItem {
                id: aboutTitle

                height: units.gu(6.25)

                divider.colorFrom: theme.palette.normal.background
                divider.colorTo: theme.palette.normal.background

                Label {
                    id: aboutTitleLabel

                    width: parent.width - units.gu(4)

                    anchors {
                        bottom: parent.bottom
                        bottomMargin: units.gu(1.25)
                        left: parent.left
                        leftMargin: units.gu(2)
                    }

                    text: "Over:"

                    color: theme.palette.normal.backgroundSecondaryText
                    elide: Text.ElideRight
                    font.bold: true
                }
            }

            ListItem {
                id: aboutListItem

                height: units.gu(6)

                ListItemLayout {
                    id: layoutAbout

                    anchors.verticalCenter: parent.verticalCenter

                    title.text: "Over deze app"
                    ProgressionSlot { color: theme.palette.normal.baseText; }
                }

                onClicked: pageStack.push(aboutPage)
            }
        }
    }

    Scrollbar {
        id: settingsScrollbar

        flickableItem: settingsFlickable
        align: Qt.AlignTrailing
    }
}