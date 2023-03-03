import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtSystemInfo 5.5
import "components"

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'ubuntu-nednieuws.sanderklootwijk'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property alias settings: settings
    property string categoryName: "Algemeen"
    property string version: "2.3"

    Settings {
        id: settings

        property bool darkMode: false
        property int selectedIndex: 1
        property real zoomFactor: 1.0

        onDarkModeChanged: Theme.name = darkMode ? "Lomiri.Components.Themes.SuruDark" : "Lomiri.Components.Themes.Ambiance"

        Component.onCompleted: Theme.name = darkMode ? "Lomiri.Components.Themes.SuruDark" : "Lomiri.Components.Themes.Ambiance"
    }

    ScreenSaver {
        id: screenSaver

        screenSaverEnabled: {
            if (Qt.application.state == Qt.ApplicationActive) {
                pageStack.currentPage == articlePage ? false : true
            }
            else {
                true
            }
        }
    }

    FeedListModel {
        id: feedListModel
    }

    PageStack {
        id: pageStack

        Component.onCompleted: push(homePage)

        HomePage {
            id: homePage

            visible: false
        }

        CategoryPage {
            id: categoryPage

            visible: false
        }

        ArticlePage {
            id: articlePage

            visible: false
        }

        AboutPage {
            id: aboutPage

            visible: false
        }
    }
}