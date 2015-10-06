import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../models"
import "../items/messageitem/media"
import "../js/TelegramConstants.js" as TelegramConstants

ContextMenu
{
    signal downloadRequested()
    signal cancelRequested()

    property Context context
    property Message message
    property MessageMediaItem messageMediaItem

    MenuItem
    {
        text: qsTr("Copy")
        visible: !message.media || (message.media.classType === TelegramConstants.typeMessageMediaEmpty)

        onClicked: {
            Clipboard.text = message.message;
            popupmessage.show(qsTr("Message copied to clipboard"));
        }
    }

    MenuItem
    {
        text: qsTr("Delete")

        onClicked: {
            messageitem.remorseAction(qsTr("Deleting Message"), function() {
                context.telegram.deleteMessages([message.id]);
            });
        }
    }

    MenuItem
    {
        text: qsTr("Download")
        visible: message.media && (message.media.classType !== TelegramConstants.typeMessageMediaEmpty) && messageMediaItem && !messageMediaItem.fileHandler.downloaded;

        onClicked: {
            messageitem.remorseAction(qsTr("Downloading media"), function() {
                downloadRequested();
            });
        }
    }

    MenuItem
    {
        text: qsTr("Cancel")
        visible: false //FIXME: message.out && loader.item && loader.item.transferInProgress
        onClicked: cancelRequested()
    }
}
