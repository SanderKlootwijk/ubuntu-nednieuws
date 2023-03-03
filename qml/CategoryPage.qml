import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import "components"

Page {
    id: categoryPage

    header: PageHeader {
        id: categoryPageHeader

        title: "Categorieën"
    }

    Flickable {
        id: categoryFlickable

        anchors {
            fill: parent
            topMargin: categoryPageHeader.height
        }

        contentWidth: categoryColumn.width
        contentHeight: categoryColumn.height

        Column {
            id: categoryColumn

            width: categoryPage.width

            CategoryListItem {
                name: "Algemeen"
                url: "https://feeds.nos.nl/nosnieuwsalgemeen"
            }

            CategoryListItem {
                name: "Binnenland"
                url: "https://feeds.nos.nl/nosnieuwsbinnenland"
            }

            CategoryListItem {
                name: "Buitenland"
                url: "https://feeds.nos.nl/nosnieuwsbuitenland"
            }

            CategoryListItem {
                name: "Politiek"
                url: "https://feeds.nos.nl/nosnieuwspolitiek"
            }

            CategoryListItem {
                name: "Economie"
                url: "https://feeds.nos.nl/nosnieuwseconomie"
            }

            CategoryListItem {
                name: "Opmerkelijk"
                url: "https://feeds.nos.nl/nosnieuwsopmerkelijk"
            }

            CategoryListItem {
                name: "Koningshuis"
                url: "https://feeds.nos.nl/nosnieuwskoningshuis"
            }

            CategoryListItem {
                name: "Technologie"
                url: "https://feeds.nos.nl/nosnieuwstech"
            }

            CategoryListItem {
                name: "Cultuur & Media"
                url: "https://feeds.nos.nl/nosnieuwscultuurenmedia"
            }

            CategoryListItem {
                name: "Voetbal"
                url: "https://feeds.nos.nl/nosvoetbal"
            }

            CategoryListItem {
                name: "Formule 1"
                url: "https://feeds.nos.nl/nossportformule1"
            }

            CategoryListItem {
                name: "Schaatsen"
                url: "https://feeds.nos.nl/nossportschaatsen"
            }

            CategoryListItem {
                name: "Wielrennen"
                url: "https://feeds.nos.nl/nossportwielrennen"
            }

            CategoryListItem {
                name: "Tennis"
                url: "https://feeds.nos.nl/nossporttennis"
            }
        }
    }
}
