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

import QtQuick 2.4
import Ubuntu.Components 1.3

ListItem {
    id: container

    height: units.gu(12)

    // Put contents in a 'box'
    Item {
        anchors {
            centerIn: parent
        }

        // Adjust width on big screens (e.g. tablets or extended display), Ubuntu Touch's convergence feature
        height: parent.height - units.gu(2)
        width: {
            if (root.width > units.gu(85)) {
                units.gu(81)
            }
            else {
                parent.width - units.gu(4)
            }
        }


        Image {
            z: 1
            id: containerImage
            width: height * 1.7
            height: parent.height
            anchors {
                top: parent.top
                left: parent.left
            }

            source: image
        }

        Rectangle {
            id: imagePlaceholder
            width: height * 1.7
            height: parent.height

            anchors.centerIn: containerImage

            color: "#7f7f7f"

            Icon {
                width: units.gu(3)
                height: width

                anchors.centerIn: parent

                name: "stock_image"
                color: "#cdcdcd"
            }
        }

        Label {
            id: containerTitle
            width: parent.width - containerImage.width - units.gu(1)
            anchors {
                left: containerImage.right
                leftMargin: units.gu(1)
                verticalCenter: parent.verticalCenter
            }

            text: title
            textSize: Label.Medium
            font.weight: Font.DemiBold
            wrapMode: Text.WordWrap
        }
    }

    onClicked: {
        articleWebView.opacity = 0
        articleWebView.stop()
        articleWebView.url = link
        pageStack.push(articlePage)
    }
}
