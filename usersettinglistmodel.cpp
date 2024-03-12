#include "usersettinglistmodel.h"

SettingListModel::SettingListModel(QObject *parent) {}

int SettingListModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return m_settings.size();
}

QVariant SettingListModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_settings.size())
    return QVariant();

  const UserSetting &setting = m_settings.at(index.row());

  switch (role) {
  case Head:
    return setting.head;
  case Back:
    return setting.back;
  case Foot:
    return setting.foot;
  case Hardness:
    return setting.hardness;
  case IsHeadAttached:
    return setting.is_head_attached;
  default:
    return QVariant();
  }
}

QHash<int, QByteArray> SettingListModel::roleNames() const {
  QHash<int, QByteArray> roles;
  roles[Head] = "head";
  roles[Back] = "back";
  roles[Foot] = "foot";
  roles[Hardness] = "hardness";
  roles[IsHeadAttached] = "is_head_attached";
  return roles;
}

QList<UserSetting> SettingListModel::getModelData() const { return m_settings; }

void SettingListModel::addSetting(uint head, bool is_head_attached, uint back,
                                  uint foot, uint hardness) {
  beginInsertRows(QModelIndex(), rowCount(), rowCount());

  UserSetting s;
  s.head = head;
  s.back = back;
  s.foot = foot;
  s.hardness = hardness;
  s.is_head_attached = is_head_attached;

  m_settings.append(s);

  endInsertRows();
}

void SettingListModel::setModelData(const QList<UserSetting> &settings) {
  beginResetModel();

  m_settings = settings;

  endResetModel();
}
