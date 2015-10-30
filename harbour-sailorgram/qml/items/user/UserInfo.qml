import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../components"
import "../../js/TelegramHelper.js" as TelegramHelper

Item
{
    property User telegramUser
    property bool allowSendMessage: true
    property bool actionVisible: false

    id: userinfo
    width: content.width
    height: column.height

    Column
    {
        id: column
        anchors { left: parent.left; top: parent.top; right: parent.right }

        ClickableLabel
        {
            visible: allowSendMessage && actionVisible
            width: parent.width
            height: Theme.itemSizeSmall
            labelFont.pixelSize: Theme.fontSizeSmall
            labelText: qsTr("Send Message")
            //FIXME: onActionRequested: pageStack.replace(Qt.resolvedUrl("../../pages/dialogs/DialogPage.qml"), { "context": context, "dialog": context.telegram.fakeDialogObject(user.id, false) } )
        }

        ClickableLabel
        {
            visible: actionVisible
            width: parent.width
            height: Theme.itemSizeSmall
            labelFont.pixelSize: Theme.fontSizeSmall
            labelText: qsTr("Begin Secret Chat")

            onActionRequested: {
                /* FIXME:
                context.telegram.messagesCreateEncryptedChat(user.id);

                var firstpage = pageStack.currentPage;

                for(var i = pageStack.depth; i > 1; i--)
                    firstpage = pageStack.previousPage(firstpage);
                    */

                pageStack.pop(firstpage);
            }
        }

        ClickableLabel
        {
            visible: actionVisible
            width: parent.width
            height: Theme.itemSizeSmall
            labelFont.pixelSize: Theme.fontSizeSmall
            labelText: telegramUser.isBlocked ? qsTr("Unblock") : qsTr("Block")
            remorseRequired: true
            remorseMessage: telegramUser.isBlocked ? qsTr("Unblocking user") : qsTr("Blocking user")

            onActionRequested: {
                telegramUser.isBlocked = !telegramUser.isBlocked;
            }
        }

        SectionHeader { text: qsTr("Phone Number") }

        Label
        {
            x: Theme.paddingMedium
            width: parent.width - (x * 2)
            text: TelegramHelper.completePhoneNumber(telegramUser.phone)
        }
    }
}
