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
#include <telegramqmlinitializer.h>
#include "telegramcalendar.h"
#include "localstorage/telegramlocalstorage.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> application(SailfishApp::application(argc, argv));
    application->setApplicationName("harbour-sailorgram");
    application->setApplicationVersion("0.5");

    TelegramQmlInitializer::init("harbour.sailorgram.TelegramQml");

    qmlRegisterType<TelegramLocalStorage>("harbour.sailorgram.Telegram", 1, 0, "TelegramLocalStorage");
    qmlRegisterSingletonType<TelegramCalendar>("harbour.sailorgram.TelegramCalendar", 1, 0, "TelegramCalendar", &TelegramCalendar::initialize);

    QScopedPointer<QQuickView> view(SailfishApp::createView());
    QQmlEngine* engine = view->engine();
    QObject::connect(engine, SIGNAL(quit()), application.data(), SLOT(quit()));

    view->setSource(SailfishApp::pathTo("qml/harbour-sailorgram.qml"));
    view->show();
    return application->exec();
}