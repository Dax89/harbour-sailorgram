import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../menus"
import "media"
import "../../js/TelegramConstants.js" as TelegramConstants
import "../../js/TelegramHelper.js" as TelegramHelper

ListItem
{
    property Context context
    property Message telegramMessage
    property User telegramFromUser

    function remorseNeeded(mediatype, type) {
        if(loader.item.fileHandler.downloaded) // No remorse for downloaded medias
            return false;

        if((mediatype === TelegramConstants.typeMessageMediaVideo) || (mediatype === TelegramConstants.typeMessageMediaAudio))
            return true;

        if((type === "audio") || (type === "video"))
            return true;

        if((mediatype === TelegramConstants.typeMessageMediaDocument) && (type !== "image"))
            return true;

        return false;
    }

    function openOrDownloadMedia(canbeviewed, type) {
        if(!loader.item.fileHandler.downloaded)
            loader.item.fileHandler.download();

        if((telegramMessage.media.classType === TelegramConstants.typeMessageMediaPhoto) || (type === "image")) {
            pageStack.push(Qt.resolvedUrl("../../pages/media/MediaPhotoPage.qml"), { "context": messageitem.context, "message": messageitem.telegramMessage, "fileHandler": loader.item.fileHandler });
            return;
        }

        if((telegramMessage.media.classType === TelegramConstants.typeMessageMediaVideo) || (telegramMessage.media.classType === TelegramConstants.typeMessageMediaAudio) || (type === "audio") || (type === "video")) {
            pageStack.push(Qt.resolvedUrl("../../pages/media/MediaPlayerPage.qml"), { "context": messageitem.context, "message": messageitem.telegramMessage, "fileHandler": loader.item.fileHandler });
            return;
        }

        if(!loader.item.fileHandler.downloaded)
            return;

        popupmessage.show(qsTr("Opening media"));
        Qt.openUrlExternally(loader.item.fileHandler.filePath);
    }

    function displayMedia() {
        if(!telegramMessage.media)
            return;

        var type = "";
        var canbeviewed = (telegramMessage.media.classType === TelegramConstants.typeMessageMediaPhoto) ||
                          (telegramMessage.media.classType === TelegramConstants.typeMessageMediaVideo) ||
                          (telegramMessage.media.classType === TelegramConstants.typeMessageMediaAudio);

        if(telegramMessage.media.classType === TelegramConstants.typeMessageMediaDocument) {
            var mime = telegramMessage.media.document.mimeType;
            type = mime.split("/")[0];
            canbeviewed = ((type === "video") || (type === "audio") || (type === "image")) ? true : false;
        }

        if(!remorseNeeded(telegramMessage.media.classType, type)) {
            openOrDownloadMedia(canbeviewed, type);
            return;
        }

        messageitem.remorseAction((canbeviewed ? qsTr("Opening Media") : qsTr("Downloading Media")), function() {
            openOrDownloadMedia(canbeviewed, type);
        });
    }

    id: messageitem
    contentWidth: parent.width
    contentHeight: content.height

    /*
    menu: MessageMenu {
        id: messagemenu
        context: messageitem.context
        message: messageitem.telegramMessage
        messageMediaItem: loader.item

        onCancelRequested: loader.item.cancelTransfer()
        onDownloadRequested: loader.item.download()
    }
    */

    onClicked: displayMedia()

    /*
    Component {
        id: documentcomponent

        MessageDocument {
            context: messageitem.context
            message: messageitem.telegramMessage
        }
    }

    Component {
        id: photocomponent

        MessagePhoto {
            context: messageitem.context
            message: messageitem.telegramMessage
        }
    }

    Component {
        id: audiocomponent

        MessageAudio {
            context: messageitem.context
            message: messageitem.telegramMessage
        }
    }

    Component {
        id: videocomponent

        MessageVideo {
            context: messageitem.context
            message: messageitem.telegramMessage
        }
    }
    */

    Column
    {
        id: content
        anchors { top: parent.top; left: parent.left; right: parent.right; leftMargin: Theme.paddingMedium; rightMargin: Theme.paddingMedium }

        Label
        {
            id: lbluser
            anchors { left: telegramMessage.isOut ? parent.left : undefined; right: telegramMessage.isOut ? undefined : parent.right }
            visible: !telegramMessage.isService && !telegramMessage.isOut
            text: (!telegramMessage.isService && telegramMessage.isOut) ? "" : TelegramHelper.fullName(telegramFromUser)
            font.bold: true
            font.pixelSize: Theme.fontSizeMedium
            wrapMode: Text.NoWrap
            horizontalAlignment: Text.AlignRight
            verticalAlignment: Text.AlignVCenter
            color: Theme.secondaryHighlightColor
        }

        /*
        Loader
        {
            id: loader
            anchors { left: message.out ? parent.left : undefined; right: message.out ? undefined : parent.right }

            sourceComponent: {
                if(message.media) {
                    if(message.media.classType === TelegramConstants.typeMessageMediaPhoto)
                        return photocomponent;
                    else if(message.media.classType === TelegramConstants.typeMessageMediaDocument)
                        return documentcomponent;
                    else if(message.media.classType === TelegramConstants.typeMessageMediaAudio)
                        return audiocomponent;
                    else if(message.media.classType === TelegramConstants.typeMessageMediaVideo)
                        return videocomponent;
                }

                return null;
            }

            onLoaded: {
            }
        }
        */

        MessageText
        {
            id: messagetext
            width: parent.width
            telegramMessage: messageitem.telegramMessage
        }
    }
}
