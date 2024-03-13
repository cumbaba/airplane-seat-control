#include "usersettinglistmodel.h"

SettingListModel::SettingListModel(QObject *parent) {}

SettingListModel::~SettingListModel() {
  while (!m_settings.empty())
    delete m_settings.front(), m_settings.pop_front();
}

int SettingListModel::rowCount(const QModelIndex &parent) const {
  Q_UNUSED(parent)
  return m_settings.size();
}

QVariant SettingListModel::data(const QModelIndex &index, int role) const {
  if (!index.isValid() || index.row() >= m_settings.size())
    return QVariant();

  if (role == Qt::DisplayRole) {
    return QVariant::fromValue(m_settings[index.row()]);
  }

  return QVariant();
}

QList<UserSetting> SettingListModel::getModelData() const {
  QList<UserSetting> res;

  for (auto *s : m_settings) {
    res.push_back(*s);
  }

  return res;
}

void SettingListModel::addSetting(uint head, bool is_head_attached, uint back,
                                  uint foot, uint hardness) {
  beginInsertRows(QModelIndex(), rowCount(), rowCount());

  UserSetting *s = new UserSetting();
  s->setHead(head);
  s->setBack(back);
  s->setFoot(foot);
  s->setHardness(hardness);
  s->setIsHeadAttached(is_head_attached);
  m_settings.append(s);

  endInsertRows();
}

void SettingListModel::setModelData(const QList<UserSetting> &settings) {
  beginResetModel();

  while (!m_settings.empty())
    delete m_settings.front(), m_settings.pop_front();

  for (auto &s : settings) {
    m_settings.push_back(new UserSetting(s));
  }

  endResetModel();
}
