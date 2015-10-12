import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../components"
import "../../items/user"
import "../../js/TelegramHelper.js" as TelegramHelper

Page
{
    property bool actionVisible: true
    property Context context
    property User user

    id: userpage
    allowedOrientations: defaultAllowedOrientations

    SilicaFlickable
    {
        id: flickable
        anchors.fill: parent
        contentHeight: content.height

        Column
        {
            id: content
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader { title: TelegramHelper.completeName(user) }

            UserItem
            {
                x: Theme.paddingMedium
                width: parent.width - (x * 2)
                height: Theme.itemSizeSmall
                context: userpage.context
                user: userpage.user
            }

            UserInfo
            {
                x: Theme.paddingMedium
                width: parent.width - (x * 2)
                actionVisible: true
                context: userpage.context
                telegramUser: userpage.user
            }
        }
    }
}
