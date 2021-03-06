import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import "./priv"

Rectangle {
  id: navigationBar

  // The tint color to apply to the navigation bar background. It is equivalent to color. It apply the naming convenient of UIKit
  property string tintColor : "#007aff"

  property alias barTintColor : navigationBar.color

  // The view objects within NavigationView
  property ListModel views : ListModel{}

  // The top most navigation item
  property NavigationItem navigationItem : dummyNavigationItem
  property ListModel navigationItems : ListModel{}

  property NavigationBarTitleAttributes titleAttributes : NavigationBarTitleAttributes {}

  signal leftClicked()

  width: parent.width
  height: 44

  color : "#f8f8f8"

  anchors.top: parent.top
  anchors.topMargin: 0
  anchors.right: parent.right
  anchors.rightMargin: 0
  anchors.left: parent.left
  anchors.leftMargin: 0

  NavigationItem {
    id : dummyNavigationItem
  }
  StackView {
      id : stack
      anchors.fill: parent
      delegate: NavigationBarTransition {}
  }

  BarButtonItem {
    id: backButton
    anchors.left: parent.left
    anchors.leftMargin: 8
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    visible: views.count > 1
    image: "qrc:///QuickIOS/images/back.png"
    tintColor: navigationBar.tintColor
    onClicked: {
      navigationBar.leftClicked();
    }
  }

  Repeater {
      id: viewsListener
      model : navigationBar.views
      delegate: Item {

          property var navigationItem : NavigationItem {}

          Component {
              id: creator
              NavigationBarItem {
                  title: navigationItem.title
                  backStage: index > 0
                  leftBarButtonItems: navigationItem.leftBarButtonItems
                  rightBarButtonItems: navigationItem.rightBarButtonItems
                  barTintColor : navigationBar.barTintColor
                  titleView.color: titleAttributes.textColor
              }
          }

          function place(parent,item) {
              item.parent = parent;
              item.anchors.centerIn = parent;
          }

          Component.onCompleted: {
              if (model.object.hasOwnProperty("navigationItem"))
                  navigationItem = model.object.navigationItem;

              navigationItems.append({ object: navigationItem});
              navigationBar.navigationItem = navigationItem;

              var object = creator.createObject(stack);

              if (navigationItem.leftBarButtonItem) {
                   navigationItem.leftBar = navigationItem.leftBarButtonItem;
              }

              if (navigationItem.rightBarButtonItem) {
                   navigationItem.rightBar = navigationItem.rightBarButtonItem;
              }

              if (navigationItem.rightBar) {
                  place(object.rightBar,navigationItem.rightBar);
              }

              if (navigationItem.leftBar) {
                  place(object.leftBar,navigationItem.leftBar);
              }

              stack.push(object);
          }

          Component.onDestruction: {
              stack.pop();
              navigationItems.remove(navigationItems.count - 1);
              if (navigationItems.count > 0)
                navigationBar.navigationItem = navigationItems.get(navigationItems.count - 1).object;
              else
                navigationBar.navigationItem = dummyNavigationItem;
          }
      }
  }


}
