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
    height: parent.height - units.gu(4)
    width: {
      if (root.width > units.gu(85)) {
        units.gu(81)
      }
      else {
        parent.width - units.gu(4)
      }
    }


    Image {
      id: containerImage
      width: height * 1.7
      height: parent.height
      anchors {
        top: parent.top
        right: parent.right
      }

      source: image
    }

    Label {
      id: containerTitle
      width: parent.width - containerImage.width - units.gu(1)
      anchors {
        left: parent.left
      }

      text: title
      textSize: Label.Medium
      wrapMode: Text.WordWrap
    }
  }

  onClicked: {
    //first scroll to top
    columnFlickable.contentY = 0
    //then add new information
    articleTitle.text = title
    articleDate.text = pubDate
    articleImage.source = image
    articleContent.text = '<font color="' + theme.palette.normal.baseText + '">' + content + '<br>&nbsp;<br>&nbsp;> </font><a href="' + link + '"><font color="#19b6ee">Open dit artikel in uw browser</font></a>'
    pageStack.push(articlePage)
  }
}
