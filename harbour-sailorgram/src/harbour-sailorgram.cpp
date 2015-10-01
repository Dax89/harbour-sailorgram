/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

#include <QtQuick>
#include <sailfishapp.h>
#include <telegram.h>
#include <model/contacts/contactsmodel.h>
#include <model/dialogs/dialogsmodel.h>
#include <model/dialogs/dialogmodel.h>
#include "dbus/screenblank.h"
#include "dbus/notifications/notifications.h"
#include "filepicker/folderlistmodel.h"
#include "sailorgram.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));

    qmlRegisterType<SailorGram>("harbour.sailorgram.SailorGram", 1, 0, "SailorGram");

    qmlRegisterType<TelegramDatabase>("harbour.sailorgram.Telegram", 1, 0, "TelegramDatabase");
    qmlRegisterType<ContactsModel>("harbour.sailorgram.Telegram", 1, 0, "ContactsModel");
    qmlRegisterType<DialogsModel>("harbour.sailorgram.Telegram", 1, 0, "DialogsModel");
    qmlRegisterType<DialogModel>("harbour.sailorgram.Telegram", 1, 0, "DialogModel");
    qmlRegisterType<Telegram>("harbour.sailorgram.Telegram", 1, 0, "Telegram");

    qmlRegisterType<DialogObject>("harbour.sailorgram.Telegram", 1, 0, "Dialog");
    qmlRegisterType<ContactObject>("harbour.sailorgram.Telegram", 1, 0, "Contact");
    qmlRegisterType<UserObject>("harbour.sailorgram.Telegram", 1, 0, "User");
    qmlRegisterType<UserProfilePhotoObject>("harbour.sailorgram.Telegram", 1, 0, "UserProfilePhoto");
    qmlRegisterType<UserStatusObject>("harbour.sailorgram.Telegram", 1, 0, "UserStatusObject");
    qmlRegisterType<ChatObject>("harbour.sailorgram.Telegram", 1, 0, "Chat");
    qmlRegisterType<ChatPhotoObject>("harbour.sailorgram.Telegram", 1, 0, "ChatPhoto");
    qmlRegisterType<MessageObject>("harbour.sailorgram.Telegram", 1, 0, "Message");
    qmlRegisterType<MessageMediaObject>("harbour.sailorgram.Telegram", 1, 0, "MessageMediaObject");
    qmlRegisterType<MessageMediaObject>("harbour.sailorgram.Telegram", 1, 0, "MessageMediaObject");

    qmlRegisterType<ScreenBlank>("harbour.sailorgram.DBus", 1, 0, "ScreenBlank");
    qmlRegisterType<Notifications>("harbour.sailorgram.DBus", 1, 0, "Notifications");
    qmlRegisterType<FolderListModel>("harbour.sailorgram.Pickers", 1, 0, "FolderListModel");

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    view->setSource(SailfishApp::pathTo("qml/harbour-sailorgram.qml"));
    view->show();
    return application->exec();
}
