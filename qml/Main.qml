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
    property string version: "2.3.2"

    theme.name: {
        switch (settings.theme) {
            case 0: return "";
            case 1: return "Lomiri.Components.Themes.Ambiance";
            case 2: return "Lomiri.Components.Themes.SuruDark";
            default: return "";
        }
    }

    Settings {
        id: settings

        property int theme: 0
        property int selectedZoomIndex: 1
        property int selectedFontIndex: 0
        property real zoomFactor: 1.0
        property string fontType: "Ubuntu"

        onSelectedFontIndexChanged: articlePage.articleWebView.reload()
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

        SettingsPage {
            id: settingsPage

            visible: false
        }

        AboutPage {
            id: aboutPage

            visible: false
        }
    }
}