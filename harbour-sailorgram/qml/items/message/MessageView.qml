import QtQuick 2.1
import Sailfish.Silica 1.0
import "../../components/telegram"
import "../../models"

SilicaListView
{
    property Context context

    id: messageview
    currentIndex: -1
    verticalLayoutDirection: ListView.BottomToTop
    spacing: Theme.paddingLarge
    cacheBuffer: height * 2
    pressDelay: 0
    clip: true

    VerticalScrollDecorator { flickable:  messageview }
    TelegramBackground { visible: !context.backgrounddisabled; z: -1 }
}
