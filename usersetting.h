#ifndef USERSETTING_H
#define USERSETTING_H

#include <QObject>

class UserSetting : public QObject {
  Q_OBJECT
  Q_PROPERTY(uint head READ head WRITE setHead NOTIFY headChanged)
  Q_PROPERTY(bool isHeadAttached READ isHeadAttached WRITE setIsHeadAttached
                 NOTIFY isHeadAttachedChanged)
  Q_PROPERTY(uint back READ back WRITE setBack NOTIFY backChanged)
  Q_PROPERTY(uint foot READ foot WRITE setFoot NOTIFY footChanged)
  Q_PROPERTY(
      uint hardness READ hardness WRITE setHardness NOTIFY hardnessChanged)

public:
  explicit UserSetting(QObject *parent = nullptr);
  UserSetting(const UserSetting &other);
  UserSetting &operator=(const UserSetting &other);

  uint head() const;
  void setHead(uint head);

  bool isHeadAttached() const;
  void setIsHeadAttached(bool isHeadAttached);

  uint back() const;
  void setBack(uint back);

  uint foot() const;
  void setFoot(uint foot);

  uint hardness() const;
  void setHardness(uint hardness);

signals:
  void headChanged();
  void isHeadAttachedChanged();
  void backChanged();
  void footChanged();
  void hardnessChanged();

private:
  uint m_head;
  bool m_isHeadAttached;
  uint m_back;
  uint m_foot;
  uint m_hardness;
};

#endif // USERSETTING_H
