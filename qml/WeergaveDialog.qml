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
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Component {
    id: weergaveDialog

    Dialog {
        signal closed();
        id: dialog
        title: "Weergave"

        Component.onCompleted: {
            selector.selectedIndex = settings.selectedIndex
        }

        OptionSelector {
            id: selector
            expanded: true
            containerHeight: parent.height * 0.75
            anchors.horizontalCenter: parent.horizontalCenter
            model: ["Klein","Normaal","Groot"]
            onSelectedIndexChanged: {
                switch(selector.selectedIndex) {
                case 0: {
                    articleWebView.zoomFactor = 0.75
                    settings.zoomFactor = 0.75
                    settings.selectedIndex = 0
                    articleWebView.zoomFactor = 0.75
                    break;
                }
                case 1: {
                    articleWebView.zoomFactor = 1.0
                    settings.zoomFactor = 1.0
                    settings.selectedIndex = 1
                    articleWebView.zoomFactor = 1.0
                    break;
                }
                case 2: {
                    articleWebView.zoomFactor = 1.25
                    settings.zoomFactor = 1.25
                    settings.selectedIndex = 2
                    articleWebView.zoomFactor = 1.25
                    break;
                }
                }
            }
        }

        Button {
            width: parent.width
            text: "Sluiten"
            color: theme.palette.normal.activity

            onClicked: {
                PopupUtils.close(dialog);
                closed();
            }
        }
    }
}
