import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.LibQTelegram 1.0
import "../"

Item
{
    readonly property real calculatedWidth: Math.max(lblfrom.calculatedWidth,
                                                     mediamessageitem.contentWidth,
                                                     lblmessage.calculatedWidth)

    property alias quoteColor: messagequote.color
    property color color: Theme.primaryColor

    id: messagereplyitem
    height: Math.max(previewcontent.height, mediamessageitem.height)

    Row
    {
        id: row
        width: parent.width
        height: parent.height
        spacing: Theme.paddingSmall

        MessageQuote { id: messagequote; height: previewcontent.height }

        MediaMessageItem
        {
            id: mediamessageitem
            message: model.messageHasReply ? model.replyItem : null
            size: parent.width

            imageDelegate: MessageReplyImage {
                anchors.fill: parent
                source: mediamessageitem.source
            }
        }

        Column
        {
            id: previewcontent
            width: parent.width

            MessageText
            {
                id: lblfrom
                font { bold: true; pixelSize: Theme.fontSizeExtraSmall }
                emojiPath: context.sailorgram.emojiPath
                width: parent.width - (Theme.paddingSmall * 2)
                horizontalAlignment: Text.AlignLeft
                visible: messagesmodel.isChat && !model.isMessageOut && !model.isMessageService
                rawText: model.replyFrom
                color: messagereplyitem.color
            }

            MessageText
            {
                id: lblmessage
                width: parent.width - (Theme.paddingSmall* 2)
                font { italic: true; pixelSize: Theme.fontSizeExtraSmall }
                emojiPath: context.sailorgram.emojiPath
                rawText: model.replyText
                maximumLineCount: 3
                wrapMode: Text.Wrap
                elide: Text.ElideRight
                color: messagereplyitem.color
                horizontalAlignment: Text.AlignLeft
            }
        }
    }
}
