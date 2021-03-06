#include <QCoreApplication>
#include <UIKit/UIKit.h>
#include "qisystemutils.h"
#include "qiviewdelegate.h"

typedef bool (*handler)(QVariantMap data);
static QMap<QString,handler> handlers;
static QISystemUtils * m_instance = 0;

static bool alertViewCreate(QVariantMap data) {
    Q_UNUSED(data);

    QIViewDelegate *delegate = [QIViewDelegate alloc];

    delegate->alertViewClickedButtonAtIndex = ^(NSInteger buttonIndex) {
        QString name = "alertViewClickedButtonAtIndex";
        QVariantMap data;
        data["buttonIndex"] = buttonIndex;
        QMetaObject::invokeMethod(m_instance,"received",Qt::DirectConnection,
                                  Q_ARG(QString , name),
                                  Q_ARG(QVariantMap,data));
    };

    NSString* title = data["title"].toString().toNSString();
    NSString* message = data["message"].toString().toNSString();
    QStringList buttons = data["buttons"].toStringList();

    UIAlertView *alert = [UIAlertView alloc ] ;
    [alert initWithTitle:title
        message:message
        delegate:delegate
        cancelButtonTitle:nil
        otherButtonTitles:nil
        ];

    for (int i = 0 ; i < buttons.size();i++) {
        NSString *btn = buttons.at(i).toNSString();
        [alert addButtonWithTitle:btn];
    }

    [alert show];

    return true;
}

QISystemUtils *QISystemUtils::instance()
{
    if (!m_instance) {
        QCoreApplication* app = QCoreApplication::instance();
        m_instance = new QISystemUtils(app);

        handlers["alertViewCreate"]  = alertViewCreate;

    }
    return m_instance;
}

QISystemUtils::QISystemUtils(QObject *parent) : QObject(parent) {
}

bool QISystemUtils::sendMessage(QString name , QVariantMap data) {
    if (!handlers.contains(name))
        return false;
    return handlers[name](data);
}
