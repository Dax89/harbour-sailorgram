import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../models"

Dialog
{
    property var selfUserProvider // LibTelegram 'Dialog' type collides with Silica one, use 'var'

    Timer // Don't flood Telegram server
    {
        id: timwait
        interval: 1000
        onTriggered: selfUserProvider.checkUsername(tfusername.text);
    }

    function validateUsername() {
        return ((tfusername.text.length >= 5) && (tfusername.text.length <= 32) && /[a-zA-Z0-9_]+/.test(tfusername.text));
    }

    id: dlgchangeusername
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop
    canAccept: !timwait.running && (selfUserProvider.isAvailable && validateUsername() || !tfusername.text.length);
    onAccepted: selfUserProvider.updateUsername(tfusername.text);

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            DialogHeader { acceptText: qsTr("Change") }

            TextField
            {
                id: tfusername
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                placeholderText: qsTr("Username")
                inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhNoAutoUppercase
                errorHighlight: !timwait.running && validateUsername() && !selfUserProvider.isAvailable

                onTextChanged: {
                    if(!validateUsername()) {
                        timwait.stop();
                        return;
                    }

                    timwait.restart();
                }
            }

            BusyIndicator
            {
                visible: timwait.running
                running: timwait.running
                anchors.horizontalCenter: parent.horizontalCenter
                size: BusyIndicatorSize.Large
            }

            Label
            {
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                visible: !timwait.running && validateUsername() && !selfUserProvider.isAvailable
                text: qsTr("This username is already occupied")
            }

            Label
            {
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignTop
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.WordWrap
                text: qsTr("You can choose an username on Telegram. If you do, other people may contact you without knowing your phone number.\n\nYou can use a-z, 0-9 and underscores.\nMinimum length is 5 characters.")
            }
        }
    }
}
