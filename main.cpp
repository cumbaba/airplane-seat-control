#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QQmlContext>

#include "settingreader.h"

int main(int argc, char *argv[]) {
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
  QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
  QGuiApplication app(argc, argv);

  QQmlApplicationEngine engine;
  const QUrl url(QStringLiteral("qrc:/main.qml"));
  QObject::connect(
      &engine, &QQmlApplicationEngine::objectCreated, &app,
      [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
          QCoreApplication::exit(-1);
      },
      Qt::QueuedConnection);

  auto readData = SettingReader::loadSettings();

  engine.load(url);

  QList<UserSetting> existingSettings;
  for (auto &setting : readData) {
    existingSettings.append(setting);

    qDebug() << "Read Profile : Foot=" << setting.foot
             << ", Back=" << setting.back;
  }

  UserSetting newSetting;
  newSetting.back = 42;
  existingSettings.append(newSetting);

  SettingReader::saveSettings(existingSettings);

  return app.exec();
}
