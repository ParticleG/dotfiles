import Quickshell
import QtQuick

PanelWindow {
  anchors {
    top: true
    left: true
    right: true
  }
  color: "transparent"
  implicitHeight: 30

  Text {
    anchors.centerIn: parent
    color: "white"
    text: "hello world"
  }
}