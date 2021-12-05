/*
 * Copyright (C) 2021  Sander Klootwijk
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * ubuntu-nednieuws is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.XmlListModel 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import QtQuick.Layouts 1.3
import QtSystemInfo 5.5
import Qt.labs.settings 1.0
import Morph.Web 0.1
import QtWebEngine 1.10

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
        property int selectedIndex: 1
        property int zoomFactor: units.dp(1.5)
    }

    // Screensaver
    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: {
            if (Qt.application.state == Qt.ApplicationActive) {
                if (pageStack.currentPage == articlePage) {
                    false
                }
                else {
                    true
                }
            }
            else {
                true
            }
        }
    }

    // Load theme, start opacity timer for no connection message, set zoomfactor
    Component.onCompleted: {
        Theme.name = "Ubuntu.Components.Themes." + settings.theme
        opacityTimer.start()
        articleWebView.zoomFactor = settings.zoomFactor
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

            // No-connection message
    Item {
        z: 3

        id: connectionMessage

        anchors.fill: parent

        opacity: 0

        Timer {
            id: opacityTimer
            interval: 1000; running: false; repeat: false
            onTriggered: connectionMessage.opacity = 1
        }

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        visible: {
            if (listView.count == "0") {
                true
            }
            else {
                false
            }
        }

        // Prevent user from using pull-to-refresh while no connection message is displayed
        MouseArea {
            z: 3
            anchors.fill: parent
            anchors.topMargin: units.gu(6)
        }

        Label {
            id: loadinglabel1
            anchors.centerIn: parent
            font.bold: true

            text: "Laden mislukt"
        }

        Label {
            id: loadinglabel2
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: loadinglabel1.bottom
                topMargin: units.gu(0.5)
            }

            text: "Het nieuws kan nu niet worden bijgewerkt"
        }

        Label {
            id: loadinglabel3
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: loadinglabel2.bottom
                topMargin: units.gu(1.5)
            }
            font.underline: true

            text: "Probeer opnieuw"
        }

        MouseArea {
                z: 4
                
                width: loadinglabel3.width + units.gu(2)
                height: loadinglabel3.height + units.gu(2)

                anchors.centerIn: loadinglabel3

                onClicked: {
                    // reload feed
                    feedListModel.reload

                    // reload listview
                    listView.model.reload()

                    // hack: adjust listview height
                    listView.height = page.height - units.gu(8.5)
                }
            }
    }

            header: PageHeader {
                z: 1
                id: pageHeader
                height: units.gu(8.5)

                Label {
                    id: title
                    anchors {
                        left: parent.left
                        top: parent.top
                        leftMargin: units.gu(2)
                        topMargin: units.gu(1.6)
                    }

                    textSize: Label.Large

                    text: "NedNieuws"
                }

                // Adjust page subTitle to current feed
                Label {
                    id: subTitle
                    anchors {
                        left: parent.left
                        top: title.bottom
                        leftMargin: units.gu(2)
                        topMargin: units.gu(0.5)
                    }

                    textSize: Label.Medium

                    color: theme.palette.normal.backgroundSecondaryText

                    text: {
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
                }

                ActionBar {
                    height: units.gu(7.9)

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
                                    "Nachtmodus"

                                }
                                else {
                                    "Dagmodus"
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
                                }
                                else {
                                    Theme.name = "Ubuntu.Components.Themes.Ambiance"
                                    settings.theme = "Ambiance"
                                }
                            }
                        }
                    ]
                }
            }

            // Prevent user from clicking behind header
            MouseArea {
                z: 1
                anchors {
                    fill: pageHeader
                }
            }

            ListView {
                id: listView

                width: parent.width
                height: parent.height

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    bottom: parent.bottom
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
                    refreshing: listView.model.status === XmlListModel.Loading
                    onRefresh: {
                        if (listView.count == "0") {
                    // reload feed
                    feedListModel.reload

                    // reload listview
                    listView.model.reload()

                    // hack: adjust listview height
                    listView.height = page.height - units.gu(8.5)
                }
                else {
                    listView.model.reload()
                }
                    }
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
                            onTriggered: PopupUtils.open(weergaveDialog)
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

                WebEngineView {
                    id: articleWebView

                    anchors {
                        fill: parent
                        topMargin: units.gu(6)
                    }

                    opacity: 0
                    settings.showScrollBars: false
                    settings.fullScreenSupportEnabled: true

                    onLoadingChanged: {
                        articleWebView.opacity = 0
                        webViewTimer.start()
                    }

                    audioMuted: {
                        if (pageStack.currentPage == page) {
                            true
                        }
                        else if (pageStack.currentPage == categoryPage) {
                            true
                        }
                        else if (articleWebView.opacity == 0) {
                            true
                        }
                        else {
                            false
                        }
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
                        onTriggered: articleWebView.opacity = 1
                    }

                    zoomFactor: units.dp(1.5)

                    profile:  WebEngineProfile {
                        id: webContext
                        persistentCookiesPolicy: WebEngineProfile.NoPersistentCookies

                        offTheRecord: true

                        userScripts: [
                            WebEngineScript {
                                id: cssinjection
                                injectionPoint: WebEngineScript.DocumentReady
                                sourceUrl: {
                                    if (settings.theme == "SuruDark") {
                                        Qt.resolvedUrl('ubuntuthemesurudark.js')
                                    }
                                    else {
                                        Qt.resolvedUrl('ubuntutheme.js')
                                    }
                                }
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

                // Workaround: prevent users from tapping on image behind header
                MouseArea {
                    z: 1
                    anchors {
                        fill: articlePageHeader
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
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

    WeergaveDialog {
        id: weergaveDialog
    }

    function openWeergaveDialog() {
        var sd = PopupUtils.open(weergaveDialog);
    }
}
