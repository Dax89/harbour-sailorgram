Name:       harbour-sailorgram

%define __provides_exclude_from ^%{_datadir}/.*$
%define __requires_exclude ^libqtelegram|.*$

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Summary:    SailorGram
Version:    0.89
Release:    13
Group:      Qt/Qt
License:    GPL3
URL:        https://github.com/QtGram/harbour-sailorgram/
Source0:    %{name}-%{version}.tar.bz2
Source101:  harbour-sailorgram-rpmlintrc
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Xml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  pkgconfig(Qt5Multimedia)
BuildRequires:  pkgconfig(Qt5Concurrent)
BuildRequires:  pkgconfig(Qt5Location)
BuildRequires:  pkgconfig(Qt5Positioning)
BuildRequires:  pkgconfig(openssl)
BuildRequires:  desktop-file-utils

%description
An unofficial Telegram Client for SailfishOS


%prep
%setup -q -n %{name}-%{version}

%build

%qtc_qmake5 APP_VERSION=%{version}

%qtc_make %{?_smp_mflags}

%install
rm -rf %{buildroot}
%qmake5_install

ln -s /usr/share/%{name}/lib/libQTelegram.so %{buildroot}/usr/share/%{name}/lib/libQTelegram.so.1
ln -s /usr/share/%{name}/lib/libQTelegram.so %{buildroot}/usr/share/%{name}/lib/libQTelegram.so.1.0
ln -s /usr/share/%{name}/lib/libQTelegram.so %{buildroot}/usr/share/%{name}/lib/libQTelegram.so.1.0.0

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%pre
systemctl-user stop harbour-sailorgram-notifications.service

if /sbin/pidof harbour-sailorgram > /dev/null; then
killall harbour-sailorgram || true
fi

%preun
systemctl-user stop harbour-sailorgram-notifications.service

if /sbin/pidof harbour-sailorgram > /dev/null; then
killall harbour-sailorgram || true
fi

%post
systemctl-user restart mce.service
systemctl-user restart ngfd.service

# Reset settings
#rm -rf /home/nemo/.cache/%{name}
#rm -rf /home/nemo/.local/share/%{name}
# << post

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/lipstick/notificationcategories/*.conf
%{_datadir}/ngfd/events.d/*.ini
%{_datadir}/dbus-1/services/*.service
%{_libdir}/systemd/user/harbour-sailorgram-notifications.service
%{_sysconfdir}/mce/10sailorgram-led.ini
%exclude %{_libdir}/cmake/*
%exclude %{_libdir}/debug/*
