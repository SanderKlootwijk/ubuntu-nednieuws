import QtQuick 2.7
import QtWebEngine 1.10
import Morph.Web 0.1

WebEngineView {
    id: articleWebView

    property alias backItemsList: backItemsList

    anchors {
        fill: parent
        topMargin: units.gu(6)
    }

    opacity: 0
    settings.showScrollBars: true
    settings.fullScreenSupportEnabled: true
    
    onLoadingChanged: {
        articleWebView.opacity = 0
        webViewTimer.start()
    }

    Timer {
        id: webViewTimer
        interval: 10; running: false; repeat: false
        onTriggered: {
            if (articleWebViewLoadProgress.text == "100") {
                opacityDelayTimer.start()
            }
            else {
                webViewTimer.start()
            }
        }
    }

    Timer {
        id: opacityDelayTimer
        interval: 500; running: false; repeat: false
        onTriggered: {
            articleWebView.opacity = 1
        }
    }

    ListView {
        id: backItemsList
        visible: false

        model: articleWebView.navigationHistory.backItems
        delegate: Item {}
    }

    zoomFactor: root.settings.zoomFactor

    profile:  WebEngineProfile {
        id: webContext
        persistentCookiesPolicy: WebEngineProfile.NoPersistentCookies

        offTheRecord: true

        userScripts: [
            WebEngineScript {
                id: cssinjection
                injectionPoint: WebEngineScript.DocumentReady
                sourceUrl: root.settings.darkMode ? Qt.resolvedUrl('../js/ubuntuthemesurudark.js') : Qt.resolvedUrl('../js/ubuntutheme.js')
                worldId: WebEngineScript.UserWorld
            }
        ]
    }

    onNavigationRequested: function(request) {

        var url = request.url.toString()

        if (url.startsWith('https://jeugdjournaal.nl')) {
            pageStack.pop()
            Qt.openUrlExternally(url)
            request.action = WebEngineNavigationRequest.IgnoreRequest
        } else if (request.navigationType === WebEngineNavigationRequest.LinkClickedNavigation) {

            if (url.startsWith('https://nos.nl/artikel/')) {
                request.action = WebEngineNavigationRequest.AcceptRequest
            } else if (url.startsWith('https://nos.nl/liveblog/')) {
                request.action = WebEngineNavigationRequest.AcceptRequest
            }  else if (url.startsWith('https://nos.nl/nieuwsuur/')) {
                request.action = WebEngineNavigationRequest.AcceptRequest
            }  else if (url.startsWith('https://nos.nl/collectie/')) {
                request.action = WebEngineNavigationRequest.AcceptRequest
            }  else if (url.startsWith('https://nos.nl/op3/')) {
                request.action = WebEngineNavigationRequest.AcceptRequest
            }  else {
                Qt.openUrlExternally(url)
                request.action = WebEngineNavigationRequest.IgnoreRequest
            }
        }
    }

    onNewViewRequested: function(request) {
        var exturl = request.requestedUrl.toString()
        Qt.openUrlExternally(exturl)
    }

    onFullScreenRequested: function(request) {
        request.accept();
        articlePageHeader.visible = !articlePageHeader.visible
        if (request.toggleOn) {
            window.showFullScreen()
            articleWebView.anchors.topMargin = 0
        }
        else {
            window.showNormal()
            articleWebView.anchors.topMargin = units.gu(6)
        }
    }
}