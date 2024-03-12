#ifndef USERSETTINGLISTMODEL_H
#define USERSETTINGLISTMODEL_H

#include <QAbstractListModel>

#include "usersetting.h"

class SettingListModel : public QAbstractListModel {
  Q_OBJECT
public:
  enum SettingRoles {
    Head = Qt::UserRole + 1,
    Back,
    Foot,
    Hardness,
    IsHeadAttached
  };
  Q_ENUMS(SettingRoles)

  SettingListModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;

  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;

  QHash<int, QByteArray> roleNames() const override;

  QList<UserSetting> getModelData() const;

  void setModelData(const QList<UserSetting> &settings);

  Q_INVOKABLE void addSetting(uint head, bool is_head_attached, uint back,
                              uint foot, uint hardness);

private:
  void loadSettings();

  QList<UserSetting> m_settings;
};

#endif // USERSETTINGLISTMODEL_H
