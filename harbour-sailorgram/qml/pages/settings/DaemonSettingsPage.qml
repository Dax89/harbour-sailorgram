import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../model"
import "../../js/Settings.js" as Settings

Dialog
{
    property Context context

    id: daemonsettingspage
    allowedOrientations: defaultAllowedOrientations
    acceptDestinationAction: PageStackAction.Pop

    onAccepted: {
        context.sailorgram.autostart = tsdaemonenabled.checked;
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width

            DialogHeader { acceptText: qsTr("Save") }

            TextSwitch
            {
                id: tsdaemonenabled
                anchors { left: parent.left; right: parent.right; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
                text: qsTr("Autostart")
                description: qsTr("SailorGram starts automatically and will continue working in background after closing")
                checked: context.sailorgram.autostart
            }
        }
    }
}
