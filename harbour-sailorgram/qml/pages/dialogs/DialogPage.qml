import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.TelegramQml 1.0
import "../../models"
import "../../menus/dialog"
import "../../components"
import "../../items/peer"
import "../../items/dialog"
import "../../items/message"
import "../../items/message/messageitem"
import "../../js/TelegramHelper.js" as TelegramHelper

Page
{
    property Context context
    property Dialog dialog
    property Chat chat
    property User user

    id: dialogpage
    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        if(TelegramHelper.isChat(dialog))
            chat = context.telegram.chat(dialog.peer.chatId);
        else
            user = context.telegram.user(dialog.peer.userId);
    }

    onStatusChanged: {
        if(status !== PageStatus.Active)
            return;

        pageStack.pushAttached(Qt.resolvedUrl("DialogInfoPage.qml"), { "context": dialogpage.context, "dialog": dialogpage.dialog, "chat": dialogpage.chat, "user": dialogpage.user });

        messagesmodel.telegram = dialogpage.context.telegram;
        messagesmodel.dialog = dialogpage.dialog;
        messagesmodel.setReaded();

        context.sailorgram.foregroundDialog = dialogpage.dialog;
        context.sailorgram.closeNotification(dialog);
    }

    RemorsePopup { id: remorsepopup }

    Connections
    {
        target: Qt.application

        onStateChanged: {
            if(Qt.application.state !== Qt.ApplicationActive)
                return;

            messagesmodel.setReaded();
        }
    }

    Timer
    {
        id: refreshtimer
        repeat: true
        interval: 10000
        running: !context.sailorgram.daemonized
        onTriggered: messagesmodel.refresh()
    }

    PopupMessage
    {
        id: popupmessage
        anchors { left: parent.left; top: parent.top; right: parent.right }
    }

    SilicaFlickable
    {
        anchors.fill: parent

        PullDownMenu
        {
            id: pulldownmenu

            MenuItem
            {
                text: qsTr("Load more messages")
                onClicked: messagesmodel.loadMore();
            }
        }

        BusyIndicator
        {
            anchors.centerIn: parent
            size: BusyIndicatorSize.Large
            running: context.sailorgram.connected && messagesmodel.refreshing && (messagesmodel.count <= 0)
            z: running ? 2 : 0
        }

        PeerItem
        {
            id: header
            visible: !context.chatheaderhidden
            anchors { left: parent.left; top: parent.top; right: parent.right; leftMargin: Theme.horizontalPageMargin; topMargin: context.chatheaderhidden ? 0 : Theme.paddingMedium }
            height: context.chatheaderhidden ? 0 : (dialogpage.isPortrait ? Theme.itemSizeSmall : Theme.itemSizeExtraSmall)
            context: dialogpage.context
            dialog: dialogpage.dialog
            chat: dialogpage.chat
            user: dialogpage.user
        }

        MessageView
        {
            id: messageview
            anchors { left: parent.left; top: header.bottom; right: parent.right; bottom: parent.bottom }
            context: dialogpage.context

            model: MessagesModel {
                id: messagesmodel
                stepCount: context.stepcount

                onCountChanged: {
                    if((count <= 0) || (Qt.application.state !== Qt.ApplicationActive))
                        return;

                    messagesmodel.setReaded(); /* We are in this chat, always mark these messages as read */
                }
            }

            delegate: MessageItem {
                context: dialogpage.context
                messageTypesPool: messageview.messageTypesPool
                message: item

                onReplyRequested: {
                    dialogreplypreview.message = item;
                    messageview.scrollToBottom();
                }
            }

            header: Item {
                width: messageview.width

                height: {
                    var h = dialogtextinput.height;

                    if(dialogreplypreview.visible)
                        h += dialogreplypreview.height;

                    return h;
                }
            }

            Column {
                id: headerarea
                y: messageview.headerItem.y
                parent: messageview.contentItem
                width: parent.width

                DialogReplyPreview {
                    id: dialogreplypreview
                    width: parent.width
                    context: dialogpage.context
                }

                DialogTextInput {
                    id: dialogtextinput
                    width: parent.width
                    messagesModel: messagesmodel
                    context: dialogpage.context
                    dialog: dialogpage.dialog
                    replyMessage: dialogreplypreview.message

                    onMessageSent: {
                        dialogreplypreview.message = null;
                    }
                }
            }
        }
    }
}
