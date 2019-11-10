import QtQuick 2.7
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

MainView {
  id: root
  objectName: 'mainView'
  applicationName: 'ubuntu-nednieuws.sanderklootwijk'
  automaticOrientation: true

  width: units.gu(45)
  height: units.gu(75)

  // Settings to save day or night mode
  Settings {
    id: settings
    property string theme: "Ambiance"
  }

  // Load theme
  Component.onCompleted: {
    Theme.name = "Ubuntu.Components.Themes." + settings.theme
  }

  // XmlListModel to fetch news
  XmlListModel {
    id: feedListModel
    source: "https://feeds.feedburner.com/nosjournaal"
    query: "/rss/channel/item"

    namespaceDeclarations: "declare namespace dc='http://purl.org/dc/elements/1.1/'; declare namespace content='http://purl.org/rss/1.0/modules/content/';"

    XmlRole { name: "title"; query: "title/string()"; }
    XmlRole { name: "link"; query: "link/string()";}
    XmlRole { name: "pubDate"; query: "pubDate/string()"; }
    XmlRole { name: "description"; query: "description/string()"; }
    XmlRole { name: "content"; query: "description/string()"; }
    XmlRole { name: "image"; query: "enclosure/@url/string()"; }
  }

  PageStack {
    id: pageStack
    Component.onCompleted: {
      push(page)
    }

    Page {
      id: page
      anchors.fill: parent

      header: PageHeader {
        id: pageHeader
        // Adjust page title to current feed
        title: {
          if (feedListModel.source == "https://feeds.feedburner.com/nosjournaal") {
            "Algemeen nieuws"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nossportalgemeen") {
            "Sportnieuws"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwsbinnenland") {
            "Binnenland"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwsbuitenland") {
            "Buitenland"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwspolitiek") {
            "Politiek"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwseconomie") {
            "Economie"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwsopmerkelijk") {
            "Opmerkelijk"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwskoningshuis") {
            "Koningshuis"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwscultuurenmedia") {
            "Cultuur & Media"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosnieuwstechnologie") {
            "Technologie"
          }
          else if (feedListModel.source == "https://feeds.feedburner.com/nosop3") {
            "NOS op 3"
          }
        }

        ActionBar {
          anchors {
            right: parent.right
            rightMargin: units.gu(1)
            verticalCenter: parent.verticalCenter
          }

          numberOfSlots: 1

          actions: [
          Action {
            text: "Categorieën"
            iconName: "tag"
            onTriggered: {
              pageStack.push(categoryPage)
            }
          },
          Action {
            text: {
              if (settings.theme == "Ambiance"){
                i18n.tr("Nachtmodus")

              }
              else {
                i18n.tr("Dagmodus")
              }
            }
            iconSource: {
              if (settings.theme == "Ambiance"){
                "img/night-mode.svg"

              }
              else {
                "img/day-mode.svg"
              }
            }
            onTriggered: {
              if (settings.theme == "Ambiance"){
                Theme.name = "Ubuntu.Components.Themes.SuruDark"
                settings.theme = "SuruDark"
                // bottomEdge moet geopend en gesloten worden voordat het nieuwe thema is toegepast. Anders toont zich een lege pagina:
                bottomEdge.commit()
                bottomEdge.collapse()
              }
              else {
                Theme.name = "Ubuntu.Components.Themes.Ambiance"
                settings.theme = "Ambiance"
                // bottomEdge moet geopend en gesloten worden voordat het nieuwe thema is toegepast. Anders toont zich een lege pagina:
                bottomEdge.commit()
                bottomEdge.collapse()
              }
            }
          }
          ]
        }
      }

      ListView {
        id: listView
        anchors {
          fill: parent
          // Prevent to hide content under header
          topMargin: units.gu(6)
        }

        // Scrollbar for listView
        Scrollbar {
          flickableItem: listView
          align: Qt.AlignTrailing
        }

        // Link to feedListModel
        model: feedListModel
        delegate: ArticleDelegate{}

        // Add pull to refresh
        PullToRefresh {
          refreshing: listView.model.status === feedListModel.Loading
          onRefresh: listView.model.reload()
        }
      }

      // Article page; this page get pushed by ArticleDelegate after clicking on a news item
      Page {
        id: articlePage
        visible: false

        header: PageHeader {
          z: 2
          id: articlePageHeader
          title: pageHeader.title
        }

        // Workaround: prevent users from tapping on image behind header
        MouseArea {
          z: 1
          anchors {
            fill: articlePageHeader
            top: parent.top
            horizontalCenter: parent.horizontalCenter
          }
        }

        // Scrollbar for columnFlickable
        Scrollbar {
          z: 1
          flickableItem: columnFlickable
          align: Qt.AlignTrailing
        }

        Flickable {
          id: columnFlickable
          anchors {
            fill: parent
            // Prevent to hide content under header
            topMargin: units.gu(6)
          }

          contentHeight: column.height

          Column {
            id: column

            // Adjust width on big screens (e.g. tablets or extended display), Ubuntu Touch's convergence feature
            width: {
              if (root.width > units.gu(65)) {
                units.gu(63)
              }
              else {
                parent.width
              }
            }

            anchors.horizontalCenter: parent.horizontalCenter

            spacing: units.gu(1)
            padding: units.gu(2)

            Label {
              id: articleTitle
              width: parent.width - units.gu(4)
              textSize: Label.Large
              wrapMode: Text.WordWrap
            }

            Image {
              id: articleImage
              width: parent.width - units.gu(4)
              height: width / 1.7

              // Open imagePopup when clicked on image
              MouseArea {
                anchors.fill: parent

                onClicked: imagePopup.visible = true
              }
            }

            Label {
              id: articleDate
              width: parent.width - units.gu(4)
              textSize: Label.XSmall
              wrapMode: Text.WordWrap
            }

            Text {
              id: articleContent
              width: parent.width - units.gu(4)
              wrapMode: Text.WordWrap
              textFormat: Text.RichText
              //Open urls in browser
              onLinkActivated: Qt.openUrlExternally(link)
            }
          }
        }

        // Image popup
        Rectangle {
          z: 3
          id: imagePopup
          visible: false

          anchors.fill: parent

          color: "black"

          Image {
            width: parent.width
            height: width / 1.7

            anchors.centerIn: parent

            source: articleImage.source
          }

          // Close button
          Rectangle {
            z: 3
            color: "#222222"

            width: units.gu(5)
            height: width

            anchors {
              left: parent.left
              top: parent.top
            }

            Icon {
              width: units.gu(3)
              height: width
              anchors.centerIn: parent

              color: "white"

              name: "close"
            }

            MouseArea {
              onClicked: imagePopup.visible = false
              anchors.fill: parent
            }
          }

          // MouseArea: dirty hack to prevent te user from clicking on the backbutton on the articlePage
          MouseArea {
            anchors.fill: parent
          }
        }

        // Category page; this page cointains more categories to keep the PullDownMenu clean
        Page {
          id: categoryPage
          visible: false
          anchors.fill: parent

          header: PageHeader {
            title: "Categorieën"
          }

          // Scrollbar for categoryColumnFlickable
          Scrollbar {
            z: 1
            flickableItem: categoryColumnFlickable
            align: Qt.AlignTrailing
          }

          Flickable {
            id: categoryColumnFlickable
            anchors {
              fill: parent
              // Prevent to hide content under header
              topMargin: units.gu(6)
            }

            contentHeight: categoryColumn.height

            Column {
              id: categoryColumn

              width: parent.width

              // Algemeen
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Algemeen"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosjournaal"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Binnenland
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Binnenland"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwsbinnenland"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Buitenland
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Buitenland"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwsbuitenland"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Politiek
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Politiek"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwspolitiek"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Economie
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Economie"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwseconomie"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Sport
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Sport"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nossportalgemeen"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Koningshuis
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Koningshuis"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwskoningshuis"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Technologie
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Technologie"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwstech"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Cultuur & Media
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Cultuur & Media"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwscultuurenmedia"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // Opmerkelijk
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "Opmerkelijk"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosnieuwsopmerkelijk"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }

              // NOS op 3
              ListItem {
                height: units.gu(6)

                Label {
                  anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                    verticalCenter: parent.verticalCenter
                  }

                  text: "NOS op 3"
                  textSize: Label.Medium
                  wrapMode: Text.WordWrap
                }

                onClicked: {
                  // load new feed
                  feedListModel.source = "https://feeds.feedburner.com/nosop3"
                  feedListModel.reload

                  // go back to previous page
                  pageStack.pop()
                }
              }
            }
          }
        }
      }
    }
  }
}
