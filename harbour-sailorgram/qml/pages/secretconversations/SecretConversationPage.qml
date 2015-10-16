import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../menus/conversation"
import "../../components"
import "../../items/peer"
import "../../items/user"
import "../../items/secretconversation"
import "../../items/messageitem"
import "../../js/TelegramHelper.js" as TelegramHelper
import "../../js/TelegramConstants.js" as TelegramConstants

Page
{
    property Context context
    property Dialog dialog
    property EncryptedChat chat: context.telegram.encryptedChat(dialog.peer.userId)
    property User user: context.telegram.user((chat.adminId === context.telegram.me) ? chat.participantId : chat.adminId)

    id: secretconversationpage
    allowedOrientations: defaultAllowedOrientations

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        pageStack.pushAttached(Qt.resolvedUrl("../conversations/ConversationInfoPage.qml"), { "context": secretconversationpage.context, "dialog": secretconversationpage.dialog, "user": secretconversationpage.user });
        context.foregroundDialog = secretconversationpage.dialog;

        messagemodel.telegram = secretconversationpage.context.telegram;
        messagemodel.dialog = secretconversationpage.dialog;
        messagemodel.setReaded();
    }

    RemorsePopup { id: remorsepopup }

    Timer
    {
        id: refreshtimer
        repeat: true
        interval: 10000
        onTriggered: messagemodel.refresh()
        Component.onCompleted: start()
    }

    PopupMessage
    {
        id: popupmessage
        anchors { left: parent.left; top: parent.top; right: parent.right }
    }

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent

        PeerItem
        {
            id: header
            visible: !context.chatheaderhidden
            anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.horizontalPageMargin; topMargin: Theme.paddingMedium }
            height: context.chatheaderhidden ? 0 : Theme.itemSizeSmall
            context: secretconversationpage.context
            telegramDialog: secretconversationpage.dialog
            telegramUser: secretconversationpage.user
        }

        SilicaListView
        {
            id: lvconversation
            anchors { left: parent.left; top: header.bottom; right: parent.right; bottom: bottomcontainer.top; topMargin: Theme.paddingSmall }
            verticalLayoutDirection: ListView.BottomToTop
            spacing: Theme.paddingLarge
            clip: true

            TelegramBackground { id: telegrambackground; visible: !context.backgrounddisabled; z: -1 }

            BusyIndicator {
                anchors.centerIn: parent
                size: BusyIndicatorSize.Large
                running: messagemodel.refreshing
            }

            model: MessagesModel {
                id: messagemodel

                onCountChanged: {
                    if(!count)
                        return;

                    messagemodel.setReaded(); /* We are in this chat, always mark these messages as read */
                }
            }

            delegate: MessageItem {
                context: secretconversationpage.context
                telegramMessage: item
            }
        }

        Item
        {
            id: bottomcontainer
            anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
            height: messagebar.height

            MessageBar
            {
                id: messagebar
                anchors { left: parent.left; bottom: parent.bottom; right: parent.right }
                context: secretconversationpage.context
                telegramDialog: secretconversationpage.dialog
                visible: chat && (chat.classType !== TelegramConstants.typeEncryptedChatDiscarded) && (chat.classType !== TelegramConstants.typeEncryptedChatWaiting)
            }

            SecretChatDiscarded
            {
                anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                chat: secretconversationpage.chat
            }

            SecretChatWaiting
            {
                anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                chat: secretconversationpage.chat
                user: secretconversationpage.user
            }
        }
    }
}
