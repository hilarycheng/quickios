/**
    NavigationStack is a part of NavgiationView
    Author: Ben Lau (benlau)
 */

import QtQuick 2.0
import QtQuick.Controls 1.2

Item {
    id: navigationView

    property ListModel views : ListModel {}
    property alias initialView : stack.initialItem

    function push(source) {
        var view;
        if (typeof source === "string") {
            var comp = Qt.createComponent(source);
            view = comp.createObject(navigationView);
        } else {
            view = source.createObject(navigationView);
        }
        stack.push(view);
        views.append({object: view});
    }

    function pop() {
        if (stack.depth == 1)
            return;
        stack.pop();
        views.remove(views.count - 1,1);
    }

    width: 100
    height: 62

    StackView {
        id : stack
        anchors.fill: parent
        delegate: NavigationViewTransition {}
    }

    onInitialViewChanged: {
        if (initialView)
            views.append({ object: initialView })
    }

}