import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"
import "../../components"

InverseMouseArea
{
    property Context context

    function sendMessage() {
        Qt.inputMethod.commit();
        context.dialogmodel.sendMessage(textarea.text.trim());
        textarea.text = "";
    }

    id: dialogtextinput

    height: {
        if(!context.telegram.dcConnected)
            return Theme.itemSizeSmall;

        return lbltimestamp.y + lbltimestamp.height + Theme.paddingSmall;
    }

    onClickedOutside: {
        textarea.focus = false;
    }

    ConnectingLabel
    {
        anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        context: dialogtextinput.context
    }

    TextArea
    {
        id: textarea
        focusOutBehavior: FocusBehavior.KeepFocus
        font.pixelSize: Theme.fontSizeSmall
        placeholderText: qsTr("Message...")
        textRightMargin: 0

        anchors {
            left: parent.left
            right: row.left
            top: parent.top
            topMargin: Theme.paddingMedium
        }
    }

    Row
    {
        id: row

        anchors {
            right: parent.right
            verticalCenter: textarea.top
            verticalCenterOffset: textarea.textVerticalCenterOffset + (textarea._editor.height - (Math.max(btnsend.height, btnselectmedia.height) / 4))
        }

        IconButton
        {
            id: btnsend
            visible: !context.sendwithreturn && textarea.text.length > 0
            icon.source: "image://theme/icon-m-message"
            onClicked: sendMessage()
        }

        IconButton
        {
            id: btnselectmedia
            visible: textarea.text.length <= 0
            icon.source: "image://theme/icon-m-attach"

            onClicked: {
                var picker = pageStack.push(Qt.resolvedUrl("../../pages/picker/FilePickerPage.qml"), { "rootPage": pageStack.currentPage });

                picker.filePicked.connect(function(file) {
                    //FIXME: context.telegram.sendFile(TelegramHelper.peerId(telegramDialog), file);
                });
            }
        }
    }

    Label
    {
        id: lbltimestamp
        color: Theme.highlightColor
        font.pixelSize: Theme.fontSizeTiny
        width: parent.width

        anchors {
            top: textarea.bottom
            topMargin: -textarea._labelItem.height - 3
            left: textarea.left
            leftMargin: Theme.horizontalPageMargin
            right: textarea.right
        }

        function updateTimestamp() {
            var date = new Date();
            text = Format.formatDate(date, Formatter.TimeValue);
            updater.interval = (60 - date.getSeconds() + 1) * 1000;
        }

        Timer {
            id: updater
            repeat: true
            triggeredOnStart: true
            running: Qt.application.active && lbltimestamp.visible
            onTriggered: lbltimestamp.updateTimestamp()
        }
    }
}
