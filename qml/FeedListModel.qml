import QtQuick 2.7
import QtQuick.XmlListModel 2.0

XmlListModel {
    id: feedListModel
    source: "https://feeds.nos.nl/nosnieuwsalgemeen"
    query: "/rss/channel/item"

    namespaceDeclarations: "declare namespace dc='http://purl.org/dc/elements/1.1/'; declare namespace content='http://purl.org/rss/1.0/modules/content/';"

    XmlRole { name: "title"; query: "title/string()"; }
    XmlRole { name: "link"; query: "link/string()";}
    XmlRole { name: "pubDate"; query: "pubDate/string()"; }
    XmlRole { name: "description"; query: "description/string()"; }
    XmlRole { name: "content"; query: "description/string()"; }
    XmlRole { name: "image"; query: "enclosure/@url/string()"; }
}