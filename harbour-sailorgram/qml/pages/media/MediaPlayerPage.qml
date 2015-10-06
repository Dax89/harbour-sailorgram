import QtQuick 2.1
import Sailfish.Silica 1.0
import harbour.sailorgram.Telegram 1.0
import "../../models"
import "../../components"
import "../../components/mediaplayer"

MediaPage
{
    id: mediaplayerpage
    allowedOrientations: defaultAllowedOrientations

    RemorsePopup { id: remorsepopup }

    PopupMessage
    {
        id: popupmessage
        anchors { left: parent.left; top: parent.top; right: parent.right }
    }

    MediaPlayer
    {
        id: mediaplayer
        anchors.fill: parent
        videoThumbnail: message.media.video.thumb.location.download.location
        videoTitle: message.media.video.caption
        videoSource: fileHandler.filePath
    }

    ProgressCircle
    {
        anchors.centerIn: parent
        width: Theme.iconSizeLarge
        height: Theme.iconSizeLarge
        visible: (fileHandler.progressPercent > 0) && (fileHandler.progressPercent < 100)
        progressValue: fileHandler.progressPercent / 100
    }
}
