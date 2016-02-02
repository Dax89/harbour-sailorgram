#include "filesmodel.h"
#include "filesmodelworker.h"

#include <QStandardPaths>
#include <QUrl>
#include <QThread>

#include <algorithm>


const QStringList FilesModel::_imagesdirpaths(QStandardPaths::standardLocations(QStandardPaths::PicturesLocation));


FilesModel::FilesModel(QObject *parent) : QAbstractListModel(parent),
    _worker(new FilesModelWorker()),
    _workerthread(new QThread())
{
    qRegisterMetaType<FilesModel::EntryList>("FilesModel::EntryList");
    qRegisterMetaType<FilesModel::Request>("FilesModel::Request");

    this->_worker->moveToThread(this->_workerthread);
    this->_workerthread->start(QThread::LowPriority);

    connect(this, &FilesModel::newRequest, this->_worker, &FilesModelWorker::handleRequest);
    connect(this->_worker, &FilesModelWorker::requestComplete, this, &FilesModel::handleCompletedRequest);
}

FilesModel::~FilesModel()
{
    this->_worker->deleteLater();
    this->_workerthread->quit();
    this->_workerthread->deleteLater();
}

QHash<int, QByteArray> FilesModel::roleNames() const
{
    QHash<int, QByteArray> hash;

    hash.insert(FilesModel::PathRole, QByteArray("path"));
    hash.insert(FilesModel::DateRole, QByteArray("date"));
    hash.insert(FilesModel::OrientationRole, QByteArray("orientation"));
    hash.insert(FilesModel::UrlRole, QByteArray("url"));
    hash.insert(FilesModel::IsDirRole, QByteArray("isDir"));
    hash.insert(FilesModel::NameRole, QByteArray("name"));

    return hash;
}

int FilesModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)

    return this->_entries.size();
}

QVariant FilesModel::data(const QModelIndex &index, int role) const
{
    int row = index.row();

    if (row >= this->_entries.size())
        return QVariant();

    switch (role)
    {
        case FilesModel::PathRole:
        {
            return this->_entries.at(row).path;
        }
        case FilesModel::DateRole:
        {
            return this->_entries.at(row).date;
        }
        case FilesModel::OrientationRole:
        {
            return this->_entries.at(row).orientation;
        }
        case FilesModel::UrlRole:
        {
            return QUrl::fromLocalFile(this->_entries.at(row).path);
        }
        case FilesModel::IsDirRole:
        {
            return this->_entries.at(row).isDir;
        }
        case FilesModel::NameRole:
        {
            return this->_entries.at(row).path.split('/').last();
        }
    }

    return QVariant();
}

void FilesModel::handleCompletedRequest(const FilesModel::Request &request, const FilesModel::EntryList &list)
{
    if (this->_request == request)
    {
        beginResetModel();

        this->_entries = list;

        endResetModel();
    }
}

void FilesModel::setSortOrder(Qt::SortOrder order)
{
    if (this->_request.sortOrder == order)
        return;

    this->_request.sortOrder = order;
    emit sortOrderChanged();

    emit newRequest(this->_request);
}

void FilesModel::setSortRole(FilesModel::Role role)
{
    if (this->_request.sortRole == role)
        return;

    this->_request.sortRole = role;
    emit sortRoleChanged();

    emit newRequest(this->_request);
}

void FilesModel::setFilter(FilesModel::Filter filter)
{
    if (this->_request.filter == filter)
        return;

    this->_request.filter = filter;
    emit filterChanged();

    emit newRequest(this->_request);
}

void FilesModel::setDirectoriesFirst(bool df)
{
    if (this->_request.directoriesFirst == df)
        return;

    this->_request.directoriesFirst = df;
    emit directoriesFirstChanged();

    emit newRequest(this->_request);
}

void FilesModel::setFolder(const QString &folder)
{
    QString temp;

    if (folder.isEmpty() || folder == QStringLiteral("HomeFolder"))
        temp = QStandardPaths::standardLocations(QStandardPaths::HomeLocation).value(0);
    else if (folder == QStringLiteral("StandardImagesFolder"))
        temp = FilesModel::_imagesdirpaths.value(0);
    else
        temp = folder;

    if (this->_request.folder == temp)
        return;

    this->_request.folder = temp;

    emit folderChanged();

    emit newRequest(this->_request);
}

void FilesModel::setRecursive(bool recursive)
{
    if (this->_request.recursive == recursive)
        return;

    this->_request.recursive = recursive;
    emit recursiveChanged();

    emit newRequest(this->_request);
}
