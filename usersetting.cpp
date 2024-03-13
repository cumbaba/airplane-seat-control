#include "usersetting.h"

UserSetting::UserSetting(QObject *parent)
    : QObject(parent), m_head(0), m_isHeadAttached(false), m_back(0), m_foot(0),
      m_hardness(0) {}

UserSetting::UserSetting(const UserSetting &other)
    : QObject(other.parent()), m_head(other.m_head),
      m_isHeadAttached(other.m_isHeadAttached), m_back(other.m_back),
      m_foot(other.m_foot), m_hardness(other.m_hardness) {}

UserSetting &UserSetting::operator=(const UserSetting &other) {
  if (this != &other) {
    m_head = other.m_head;
    m_isHeadAttached = other.m_isHeadAttached;
    m_back = other.m_back;
    m_foot = other.m_foot;
    m_hardness = other.m_hardness;
  }
  return *this;
}

uint UserSetting::head() const { return m_head; }

void UserSetting::setHead(uint head) {
  if (m_head != head) {
    m_head = head;
    emit headChanged();
  }
}

bool UserSetting::isHeadAttached() const { return m_isHeadAttached; }

void UserSetting::setIsHeadAttached(bool isHeadAttached) {
  if (m_isHeadAttached != isHeadAttached) {
    m_isHeadAttached = isHeadAttached;
    emit isHeadAttachedChanged();
  }
}

uint UserSetting::back() const { return m_back; }

void UserSetting::setBack(uint back) {
  if (m_back != back) {
    m_back = back;
    emit backChanged();
  }
}

uint UserSetting::foot() const { return m_foot; }

void UserSetting::setFoot(uint foot) {
  if (m_foot != foot) {
    m_foot = foot;
    emit footChanged();
  }
}

uint UserSetting::hardness() const { return m_hardness; }

void UserSetting::setHardness(uint hardness) {
  if (m_hardness != hardness) {
    m_hardness = hardness;
    emit hardnessChanged();
  }
}
