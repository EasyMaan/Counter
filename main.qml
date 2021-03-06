/*******************************************************************/

/* Original File Name: main.qml                                    */

/* Date: 21-06-2018                                                */

/* Developer: Dionysus Benstein                                    */

/* Copyright © 2018 Dionysus Benstein. All rights reserved.        */

/* Description: Основное окно программы.                           */

/*******************************************************************/

import QtQuick 2.11
import QtQuick.Window 2.3
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import Qt.labs.settings 1.0
import QtQuick.Controls.Material 2.3

import com.enclave.counter 1.4

ApplicationWindow {
    id: mainWindow
    width: 640
    height: 480
    visible: true
    minimumWidth: 550
    minimumHeight: 350
    flags: Qt.FramelessWindowHint | Qt.Window
    Material.theme: appBar.popupMenu.currentIndex === 0 ? Material.Light : Material.Dark
    Material.accent: primaryColor

    readonly property color closeButtonColor: "#e81123"
    readonly property color lightFontColor: "#9a9a9a"
    readonly property color darkFontColor: "#404040"
    readonly property string appVersion: "2.9.4"
    property color primaryColor: "#e91e63"
    property color lightColor: "#ff6090"
    property color darkColor: "#b0003a"
    property int borderSize: 3
    property int cornerSize: 5
    property int previousX
    property int previousY

    function isMaximize() {
        return mainWindow.visibility === ApplicationWindow.Maximized
    }

    FontLoader { id: robotoThinFont; source: "fonts/Roboto-Thin_0.ttf"       }
    FontLoader { id: robotoLightFont; source: "fonts/Roboto-Light.ttf"       }
    FontLoader { id: robotoMediumFont; source: "fonts/Roboto-Medium.ttf"     }
    FontLoader { id: robotoRegularFont; source: "fonts/Roboto-Regular_0.ttf" }

    MouseArea {
        id: bottomArea
        height: borderSize
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: cornerSize
            rightMargin: cornerSize
        }

        cursorShape: Qt.SizeVerCursor
        onPressed: previousY = mouseY
        onMouseYChanged: {
            var dy = mouseY - previousY
            if ((mainWindow.height + dy) >= mainWindow.minimumHeight) {
                mainWindow.setHeight(mainWindow.height + dy)
            }
        }
    }

    MouseArea {
        id: leftArea
        width: borderSize
        anchors {
            left: parent.left
            top: appBar.bottom
            bottom: bottomArea.top
        }

        cursorShape: Qt.SizeHorCursor
        onPressed: previousX = mouseX
        onMouseXChanged: {
            var dx = mouseX - previousX
            if ((mainWindow.width - dx) >= mainWindow.minimumWidth) {
                mainWindow.setX(mainWindow.x + dx)
                mainWindow.setWidth(mainWindow.width - dx)
            }
        }
    }

    MouseArea {
        id: rightArea
        width: borderSize
        anchors {
            right: parent.right
            top: appBar.bottom
            bottom: bottomArea.top
        }

        cursorShape: Qt.SizeHorCursor
        onPressed: previousX = mouseX
        onMouseXChanged: {
            var dx = mouseX - previousX
            if ((mainWindow.width + dx) >= mainWindow.minimumWidth) {
                mainWindow.setWidth(mainWindow.width + dx)
            }
        }
    }

    MouseArea {
        id: bottomLeftArea
        height: cornerSize
        width: cornerSize
        anchors {
            left: parent.left
            bottom: parent.bottom
        }

        cursorShape:  Qt.SizeBDiagCursor
        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            if ((mainWindow.width - dx) >= mainWindow.minimumWidth) {
                mainWindow.setX(mainWindow.x + dx)
                mainWindow.setWidth(mainWindow.width - dx)
            }
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            if ((mainWindow.height + dy) >= mainWindow.minimumHeight) {
                mainWindow.setHeight(mainWindow.height + dy)
            }
        }
    }

    MouseArea {
        id: bottomRightArea
        height: cornerSize
        width: cornerSize
        anchors {
            right: parent.right
            bottom: parent.bottom
        }

        cursorShape:  Qt.SizeFDiagCursor
        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            if ((mainWindow.width + dx) >= mainWindow.minimumWidth) {
                mainWindow.setWidth(mainWindow.width + dx)
            }
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            if ((mainWindow.height + dy) >= mainWindow.minimumHeight) {
                mainWindow.setHeight(mainWindow.height + dy)
            }
        }
    }

    MouseArea {
        id: posChangedMouseArea
        anchors {
            left: leftArea.right
            right: rightArea.left
            top: appBar.bottom
            bottom: bottomArea.top
        }

        onPositionChanged: if (isMaximize()) mainWindow.showNormal()
        onDoubleClicked: {
            previousX = mouseX
            previousY = mouseY
            isMaximize() ? mainWindow.showNormal() : mainWindow.showMaximized()

        }

        onPressed: {
            previousX = mouseX
            previousY = mouseY
        }

        onMouseXChanged: {
            var dx = mouseX - previousX
            mainWindow.setX(mainWindow.x + dx)
        }

        onMouseYChanged: {
            var dy = mouseY - previousY
            mainWindow.setY(mainWindow.y + dy)
        }
    }

    TitleBar { id: titleBar }
    AppBar   { id: appBar   }
    Counter  { id: backEnd  }

    ScrollView {
        id: scrollView
        anchors {
            left: parent.left
            right: parent.right
            top: appBar.bottom
            bottom: cbGrid.top
            margins: 19
        }

        TextArea {
            id: input
            anchors.fill: input
            focus: true
            selectByMouse: true
            persistentSelection: true
            wrapMode: Text.Wrap
            placeholderText: qsTr("Введите текст...")
            ContextMenu { id: contextMenu; anchors.fill: parent }
        }
    }

    GridLayout {
        id: cbGrid
        anchors {
            bottom: parent.bottom
            left: parent.left
            margins: 19
        }

        rows: 2
        columns: 2

        CheckBox {
            id: spacesCounter
            text: qsTr(" Не учитывать пробелы")
            onClicked: {
                if (linesCounter.checked || wordsCounter.checked) {
                    wordsCounter.checked  = false
                    linesCounter.checked  = false
                    spacesCounter.checked = true
                }
            }
        }

        CheckBox {
            id: signsCounter
            text: qsTr(" Не учитывать знаки")
            onClicked: {
                if (linesCounter.checked || wordsCounter.checked) {
                    wordsCounter.checked = false
                    linesCounter.checked = false
                    signsCounter.checked = true
                }
            }
        }

        CheckBox {
            id: linesCounter
            text: qsTr(" Посчитать количество строк")
            onClicked: {
                if (wordsCounter.checked || signsCounter.checked || spacesCounter.checked) {
                    wordsCounter.checked  = false
                    signsCounter.checked  = false
                    spacesCounter.checked = false
                    linesCounter.checked  = true
                }
            }
        }

        CheckBox {
            id: wordsCounter;
            text: qsTr(" Посчитать количество слов")
            onClicked: {
                if (linesCounter.checked || signsCounter.checked || spacesCounter.checked) {
                    linesCounter.checked  = false
                    signsCounter.checked  = false
                    spacesCounter.checked = false
                    wordsCounter.checked  = true
                }
            }
        }
    }

    Item {
        width: 100
        height: 100
        anchors {
            left: cbGrid.right
            right: rightArea.left
            top: scrollView.bottom
            bottom: bottomArea.top
            margins: 19
        }

        Text {
            id: counter
            anchors.centerIn: parent
            color: Material.theme === Material.Dark ? "white" : darkFontColor
            text: {
                if (spacesCounter.checked) {
                    backEnd.lengthWithoutSpaces(input.text)
                } else if (signsCounter.checked) {
                    backEnd.lengthWithoutSigns(input.text)
                } else if (wordsCounter.checked) {
                    backEnd.wordsCounter(input.text)
                } else if (linesCounter.checked) {
                    input.lineCount.toString()
                } else {
                    input.text.length.toString()
                }
            }

            font.pixelSize: 40
            onTextChanged: {
                textOpacityAnim.running = true
                textScaleAnim.running = true
            }
        }
    }

    Settings {
        id: settings
        property alias currentLanguage: appBar.currentLanguage
        property alias primaryColor: mainWindow.primaryColor
        property alias lightColor: mainWindow.lightColor
        property alias darkColor: mainWindow.darkColor
    }

    ScaleAnimator {
        id: textScaleAnim
        easing.type: Easing.OutCubic
        target: counter
        from: 0; to: 1
        running: false
        duration: 100
    }

    OpacityAnimator {
        id: textOpacityAnim
        easing.type: Easing.OutCubic
        target: counter
        from: 0; to: 1
        running: false
        duration: 100
    }
}
