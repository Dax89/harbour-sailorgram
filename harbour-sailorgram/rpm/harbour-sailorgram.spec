# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-sailorgram

# >> macros
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}
Summary:    SailorGram
Version:    0.73
Release:    5
Group:      Qt/Qt
License:    GPL3
URL:        https://github.com/Dax89/harbour-sailorgram/
Source0:    %{name}-%{version}.tar.bz2
Source100:  harbour-sailorgram.yaml
Source101:  harbour-sailorgram-rpmlintrc
Requires:   sailfishsilica-qt5 >= 0.10.9
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Xml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  pkgconfig(Qt5DBus)
BuildRequires:  pkgconfig(Qt5Multimedia)
BuildRequires:  pkgconfig(openssl)
BuildRequires:  desktop-file-utils

%description
An unofficial Telegram Client for SailfishOS


%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}

# >> build post
# << build post

%install
rm -rf %{buildroot}
# >> install pre
# << install pre
%qmake5_install

# >> install post
mkdir -p %{buildroot}/usr/lib/systemd/user/post-user-session.target.wants
ln -s ../harbour-sailorgram-notifications.service %{buildroot}/usr/lib/systemd/user/post-user-session.target.wants/harbour-sailorgram-notifications.service
# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop

%pre
# >> pre
systemctl-user stop harbour-sailorgram-notifications.service

if /sbin/pidof harbour-sailorgram > /dev/null; then
killall harbour-sailorgram || true
fi
# << pre

%preun
# >> preun
systemctl-user stop harbour-sailorgram-notifications.service

if /sbin/pidof harbour-sailorgram > /dev/null; then
killall harbour-sailorgram || true
fi

# << preun
%post
# >> post
systemctl-user restart ngfd.service
systemctl-user restart harbour-sailorgram-notifications.service
# << post

%files
%defattr(-,root,root,-)
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/86x86/apps/%{name}.png
%{_datadir}/lipstick/notificationcategories/*.conf
%{_datadir}/ngfd/events.d/*.ini
%{_datadir}/dbus-1/services/*.service
%{_libdir}/systemd/user/harbour-sailorgram-notifications.service
%{_libdir}/systemd/user/post-user-session.target.wants/harbour-sailorgram-notifications.service
# >> files
# << files
