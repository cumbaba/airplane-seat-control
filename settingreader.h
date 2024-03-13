#ifndef SETTINGREADER_H
#define SETTINGREADER_H

#include "usersetting.h"

#include <QDir>
#include <QSettings>

static const char *FILE_PATH_SETTINGS = "settings.ini";

class SettingReader {
public:
  static void saveSettings(const QList<UserSetting> &settingList) {
    // Save settings to file
    QSettings settings(QDir::currentPath() + FILE_PATH_SETTINGS,
                       QSettings::IniFormat);
    settings.clear(); // Clear existing settings before writing
    settings.beginWriteArray("profiles");

    for (int i = 0; i < settingList.size(); ++i) {
      settings.setArrayIndex(i);

      settings.setValue("is_head_attached", settingList[i].isHeadAttached());
      settings.setValue("head", settingList[i].head());
      settings.setValue("back", settingList[i].back());
      settings.setValue("foot", settingList[i].foot());
      settings.setValue("hardness", settingList[i].hardness());
    }
    settings.endArray();

    settings.sync();
  }

  static QList<UserSetting> loadSettings() {
    QList<UserSetting> readSettings;

    QSettings settings(QDir::currentPath() + FILE_PATH_SETTINGS,
                       QSettings::IniFormat);
    int size = settings.beginReadArray("profiles");

    for (int i = 0; i < size; ++i) {
      settings.setArrayIndex(i);
      UserSetting s;

      s.setIsHeadAttached(settings.value("is_head_attached").toBool());
      s.setHead(settings.value("head").toUInt());
      s.setFoot(settings.value("foot").toUInt());
      s.setBack(settings.value("back").toUInt());
      s.setHardness(settings.value("hardness").toUInt());

      readSettings.append(s);
    }

    settings.endArray();

    return readSettings;
  }
};

#endif // SETTINGREADER_H
