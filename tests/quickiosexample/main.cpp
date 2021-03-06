#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "qisystemutils.h"
#include "quickios.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Quick iOS Initialization
    engine.addImportPath("qrc:///");
    QuickIOS::registerTypes(); // It must be called before loaded any scene
    // End of Quick iOS Initialization

    engine.rootContext()->setContextProperty("System",QISystemUtils::instance());

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
