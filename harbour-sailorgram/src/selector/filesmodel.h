#ifndef FILESMODEL_H
#define FILESMODEL_H


#include <QAbstractListModel>


class FilesModelWorker;
class QThread;

class FilesModel : public QAbstractListModel
{
    friend class FilesModelWorker;

    Q_OBJECT
    Q_ENUMS(Role)
    Q_ENUMS(Filter)
    Q_PROPERTY(FilesModel::Role sortRole READ sortRole WRITE setSortRole NOTIFY sortRoleChanged)
    Q_PROPERTY(FilesModel::Filter filter READ filter WRITE setFilter NOTIFY filterChanged)
    Q_PROPERTY(Qt::SortOrder sortOrder READ sortOrder WRITE setSortOrder NOTIFY sortOrderChanged)
    Q_PROPERTY(bool directoriesFirst READ directoriesFirst WRITE setDirectoriesFirst NOTIFY directoriesFirstChanged)
    Q_PROPERTY(QString folder READ folder WRITE setFolder NOTIFY folderChanged)
    Q_PROPERTY(bool recursive READ recursive WRITE setRecursive NOTIFY recursiveChanged)

public:

    enum Role { PathRole = 0, DateRole = 1, OrientationRole = 2 , UrlRole = 3, IsDirRole = 4, NameRole = 5 };
    enum Filter { NoFilter = 0, ImagesFilter = 1 };

    struct Entry
    {
        QString path;
        qint64 date;
        int orientation;
        bool isDir;
    };
    typedef QList<Entry> EntryList;

    struct Request
    {
        FilesModel::Role sortRole = FilesModel::DateRole;
        FilesModel::Filter filter = FilesModel::NoFilter;
        Qt::SortOrder sortOrder = Qt::DescendingOrder;
        bool directoriesFirst = true;
        bool recursive = false;
        QString folder;

        bool operator==(const Request &r2) const
        {
            return directoriesFirst == r2.directoriesFirst &&
                   recursive == r2.recursive &&
                   sortOrder == r2.sortOrder &&
                   sortRole == r2.sortRole &&
                   folder == r2.folder;
        }
    };

    explicit FilesModel(QObject *parent = Q_NULLPTR);
    ~FilesModel();

    int rowCount(const QModelIndex &parent = QModelIndex()) const Q_DECL_OVERRIDE;
    QVariant data(const QModelIndex &index, int role) const Q_DECL_OVERRIDE;
    QHash<int, QByteArray> roleNames() const Q_DECL_OVERRIDE;

    FilesModel::Role sortRole() const { return this->_request.sortRole; }
    FilesModel::Filter filter() const { return this->_request.filter; }
    Qt::SortOrder sortOrder() const { return this->_request.sortOrder; }
    bool directoriesFirst() const { return this->_request.directoriesFirst; }
    QString folder() const { return this->_request.folder; }
    bool recursive() const { return this->_request.recursive; }
    void setSortRole(FilesModel::Role);
    void setFilter(FilesModel::Filter);
    void setSortOrder(Qt::SortOrder);
    void setDirectoriesFirst(bool);
    void setFolder(const QString&);
    void setRecursive(bool);

signals:

    void sortRoleChanged();
    void filterChanged();
    void sortOrderChanged();
    void directoriesFirstChanged();
    void folderChanged();
    void recursiveChanged();
    void newRequest(FilesModel::Request);

private:

    FilesModelWorker *_worker;
    QThread *_workerthread;
    FilesModel::EntryList _entries;
    FilesModel::Request _request;

    static const QStringList _imagesdirpaths;

private slots:

    void handleCompletedRequest(const FilesModel::Request &request, const FilesModel::EntryList &list);
};

Q_DECLARE_METATYPE(FilesModel::Entry)
Q_DECLARE_METATYPE(FilesModel::Request)


#endif // FILESMODEL_H