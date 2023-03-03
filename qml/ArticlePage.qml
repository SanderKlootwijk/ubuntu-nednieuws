import QtQuick 2.7
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import QtQuick.Layouts 1.3
import "components"

Page {
    id: articlePage

    property alias articleWebView: articleWebView

    header: PageHeader {
        id: articlePageHeader

        leadingActionBar.actions: [
            Action {
                iconName: "back"
                text: "Terug"
                onTriggered: {
                    if (articleWebView.canGoBack == true) {
                        if (articleWebView.backItemsList.count == 1) {
                            // clear webview
                            articleWebView.url = "about:blank"

                            // pop articlePage
                            pageStack.pop()
                        }
                        else {
                            articleWebView.goBack()
                        }
                    }
                    else {
                        // clear webview
                            articleWebView.url = "about:blank"

                        // pop articlePage
                        pageStack.pop()
                    }
                }
            }
        ]

        trailingActionBar.actions: [
            Action {
                visible: {
                    if (articleWebView.opacity == 0) {
                        false
                    }
                    else {
                        true
                    }
                }
                text: "Open in browser"
                iconName: "external-link"
                onTriggered: {
                    Qt.openUrlExternally(articleWebView.url)
                }
            },
            Action {
                visible: {
                    if (articleWebView.opacity == 0) {
                        false
                    }
                    else {
                        true
                    }
                }
                text: "Tekstgrootte"
                iconSource: "img/font-size.svg"
                onTriggered: PopupUtils.open(zoomDialog)
            }
        ]
    }

    ActivityIndicator {
        anchors.centerIn: parent
        running: {
            if (articleWebViewLoadProgress.text == "100") {
                false
            }
            else {
                true
            }
        }
    }

    Label {
        id: articleWebViewLoadProgress
        anchors.centerIn: parent
        text: articleWebView.loadProgress
        color: theme.palette.normal.activity

        opacity: {
            if (articleWebViewLoadProgress.text == "100") {
                0
            }
            else {
                1
            }
        }
    }

    // This MouseArea prevents the user from scrolling while the WebView is loading
    MouseArea {
        z: 1
        anchors.fill: articleWebView

        visible: {
            if (articleWebViewLoadProgress.text == "100") {
                false
            }
            else {
                true
            }
        }
    }
    
    ArticleWebview {
        id: articleWebView

        anchors {
            fill: parent
            topMargin: articlePageHeader.height
        }
    }

    ZoomDialog {
        id: zoomDialog
    }
}
