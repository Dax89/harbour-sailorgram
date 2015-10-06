import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../components"
import "../../js/TelegramHelper.js" as TelegramHelper

Item
{
    readonly property real maxHeight: pageStack.currentPage.height / 2
    property Context context
    property Dialog dialog

    id: messagebar
    height: context.telegram.dcConnected ? (Math.max(Math.min(textarea._contentItem.contentHeight, maxHeight), btnselectmedia.height) + lbltime.contentHeight) : Theme.itemSizeSmall

    function sendMessage()
    {
        Qt.inputMethod.commit();
        dialogmodel.sendMessage(textarea.text.trim(), (dialogmodel.count > 0 ? true : false));
        textarea.text = "";
    }

    ConnectingLabel
    {
        anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        context: messagebar.context
    }

    Timer
    {
        interval: 60000
        triggeredOnStart: true
        repeat: true
        running: (Qt.application.state === Qt.ApplicationActive)

        onTriggered: {
            var date = new Date();
            lbltime.text = Format.formatDate(date, Formatter.TimeValue);
        }
    }

    Row
    {
        anchors { left: parent.left; top: parent.top; right: parent.right; bottom: lbltime.top }
        visible: context.telegram.dcConnected

        TextArea
        {
            id: textarea
            width: parent.width - (btnselectmedia.visible ? btnselectmedia.width : btnsend.width)
            anchors { top: parent.top; bottom: parent.bottom }
            placeholderText: qsTr("Message...")
            focusOutBehavior: FocusBehavior.KeepFocus
            font.pixelSize: Theme.fontSizeSmall
            labelVisible: false
            wrapMode: TextEdit.Wrap

            EnterKey.onClicked: {
                if(!context.sendwithreturn)
                    return;

                sendMessage();
            }
        }

        IconButton
        {
            id: btnsend
            anchors.bottom: parent.bottom
            visible: !context.sendwithreturn && textarea.text.length > 0
            width: visible ? Theme.itemSizeSmall : 0
            icon.source: "image://theme/icon-m-message"
            onClicked: sendMessage()
        }

        IconButton
        {
            id: btnselectmedia
            anchors.bottom: parent.bottom
            visible: textarea.text.length <= 0
            width: visible ? Theme.itemSizeSmall : 0
            icon.source: "image://theme/icon-m-attach"

            onClicked: {
                var picker = pageStack.push(Qt.resolvedUrl("../../pages/picker/FilePickerPage.qml"), { "rootPage": pageStack.currentPage });

                picker.filePicked.connect(function(file) {
                    context.telegram.sendFile(TelegramHelper.peerId(dialog), file);
                });
            }
        }
    }

    Label
    {
        id: lbltime
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: Theme.horizontalPageMargin; bottomMargin: Theme.paddingSmall }
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeTiny
        width: parent.width
    }
}
