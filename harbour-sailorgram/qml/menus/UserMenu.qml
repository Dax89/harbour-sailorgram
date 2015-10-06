import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../models"
import "../items/user"
import "../js/TelegramHelper.js" as TelegramHelper

ContextMenu
{
    property Context context
    property User user

    id: usermenu

    MenuItem
    {
        text: qsTr("Send Message")
        onClicked: pageStack.replace(Qt.resolvedUrl("../pages/conversations/ConversationPage.qml"), { "context": usermenu.context, "dialog": usermenu.context.telegram.fakeDialogObject(usermenu.user.id, false) } )
    }

    MenuItem
    {
        text: qsTr("Profile")
        onClicked: pageStack.push(Qt.resolvedUrl("../pages/users/UserPage.qml"), {"context": usermenu.context, "user": usermenu.user })
    }
}
