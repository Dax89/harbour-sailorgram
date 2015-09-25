import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../items/contact"
import "../../menus"

Page
{
    property Context context

    id: contactspage
    allowedOrientations: defaultAllowedOrientations

    SilicaListView
    {
        anchors.fill: parent
        spacing: Theme.paddingMedium
        header: PageHeader { title: qsTr("Contacts") }
        model: context.contacts

        delegate: ListItem {
            contentWidth: parent.width
            contentHeight: Theme.itemSizeSmall

            /*
            menu: ContactMenu {
                id: contactmenu
                context: contactspage.context
                user: context.telegram.user(item.userId)
            }
            */

            onClicked: pageStack.replace(Qt.resolvedUrl("../dialogs/ConversationPage.qml"), { "context": contactspage.context, "dialog": context.telegram.fakeDialogObject(item.userId, false) } )

            ContactItem {
                id: useritem
                anchors.fill: parent
                context: contactspage.context
                firstName: contactFirstName
                lastName: contactLastName
            }
        }
    }
}
