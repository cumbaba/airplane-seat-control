#ifndef USERSettingListModel_H
#define USERSettingListModel_H

#include <QAbstractListModel>

#include "usersetting.h"

class SettingListModel : public QAbstractListModel {
  Q_OBJECT
public:
  SettingListModel(QObject *parent = nullptr);

  int rowCount(const QModelIndex &parent = QModelIndex()) const override;

  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;

  QList<UserSetting> getModelData() const;

  void setModelData(const QList<UserSetting> &settings);

  Q_INVOKABLE void addSetting(uint head, bool is_head_attached, uint back,
                              uint foot, uint hardness);

private:
  QList<UserSetting *> m_settings;
};

#endif // USERSettingListModel_H
