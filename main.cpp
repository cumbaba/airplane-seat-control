#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <QColor>
#include <QQmlContext>

#include "settingreader.h"
#include "usersettinglistmodel.h"

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

  SettingListModel model;
  model.setModelData(SettingReader::loadSettings());

  QObject::connect(&app, &QGuiApplication::aboutToQuit, [&model]() {
    SettingReader::saveSettings(model.getModelData());
  });

  engine.rootContext()->setContextProperty("settingListModel", &model);
  engine.rootContext()->setContextProperty("favColor", QColor(5, 22, 77));
  engine.load(url);

  return app.exec();
}
