// Live falling-code background (same technique as the built-in Rain design)
// with a retro CRT terminal card on top instead of a plain clock.
import QtQuick
import qs.Commons
import "../plugins/io.github.sirjul1337.lock-explorer/designs"

DesignBase {
  id: lock
  inputItem: field.input

  readonly property int cellSize: 20
  readonly property string glyphs: "ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝ0123456789"
  property var drops: []

  Rectangle { anchors.fill: parent; color: Qt.darker(Color.background, 1.4) }

  Canvas {
    id: canvas
    anchors.fill: parent
    renderStrategy: Canvas.Cooperative

    function resetDrops() {
      var cols = Math.ceil(width / lock.cellSize)
      var d = []
      for (var i = 0; i < cols; i++) d.push({ y: Math.random() * -50, speed: 0.4 + Math.random() * 0.8 })
      lock.drops = d
      if (available) { var ctx = getContext("2d"); ctx.reset() }
    }
    onWidthChanged: resetDrops()
    onHeightChanged: resetDrops()
    onAvailableChanged: if (available) resetDrops()

    onPaint: {
      var ctx = getContext("2d")
      var bg = Qt.darker(Color.background, 1.4)
      ctx.fillStyle = Qt.rgba(bg.r, bg.g, bg.b, 0.18)
      ctx.fillRect(0, 0, width, height)
      ctx.font = "bold " + (lock.cellSize - 4) + "px " + Style.font.family
      var accent = Color.lock.borderActive
      var head = Color.lock.text
      var rows = height / lock.cellSize
      var d = lock.drops
      for (var i = 0; i < d.length; i++) {
        var ch = lock.glyphs.charAt(Math.floor(Math.random() * lock.glyphs.length))
        var x = i * lock.cellSize
        var y = Math.floor(d[i].y) * lock.cellSize
        ctx.fillStyle = Qt.rgba(accent.r, accent.g, accent.b, 0.85)
        ctx.fillText(ch, x, y)
        ctx.fillStyle = Qt.rgba(head.r, head.g, head.b, 0.9)
        ctx.fillText(lock.glyphs.charAt(Math.floor(Math.random() * lock.glyphs.length)), x, y + lock.cellSize)
        d[i].y += d[i].speed
        if (d[i].y > rows + 10 && Math.random() > 0.97) { d[i].y = Math.random() * -20; d[i].speed = 0.4 + Math.random() * 0.8 }
      }
    }
  }

  Timer {
    interval: 66
    running: canvas.visible
    repeat: true
    onTriggered: canvas.requestPaint()
  }

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onClicked: { lock.wakeRequested(); lock.forcePasswordFocus() }
    onPositionChanged: lock.wakeRequested()
  }

  // Retro CRT terminal card
  Rectangle {
    id: card
    anchors.centerIn: parent
    width: 480
    height: col.implicitHeight + 64
    radius: 14
    color: Qt.rgba(0, 0.02, 0, 0.85)
    border.width: 3
    border.color: lock.withAlpha(Color.lock.borderActive, 0.9)

    Rectangle {
      anchors.fill: parent
      anchors.margins: 9
      radius: 8
      color: "transparent"
      border.width: 1
      border.color: lock.withAlpha(Color.lock.text, 0.4)
    }

    // Scanline overlay
    Item {
      anchors.fill: parent
      anchors.margins: 4
      clip: true
      Repeater {
        model: Math.ceil(card.height / 3)
        Rectangle {
          required property int index
          x: 0
          y: index * 3
          width: card.width
          height: 1
          color: Qt.rgba(0, 0, 0, 0.25)
        }
      }
    }

    Column {
      id: col
      anchors.centerIn: parent
      spacing: 10
      width: parent.width - 64

      Text {
        text: "OMARCHY TERMINAL v1.0"
        color: Color.lock.borderActive
        font.family: Style.font.family
        font.bold: true
        font.pixelSize: Style.font.heading
      }
      Item { width: 1; height: 4 }
      Text {
        text: "> WAKE UP, " + lock.userName.toUpperCase() + "..."
        color: lock.withAlpha(Color.lock.text, 0.75)
        font.family: Style.font.family
        font.pixelSize: Style.font.body
      }
      Text {
        text: "> THE SYSTEM IS WATCHING."
        color: lock.withAlpha(Color.lock.text, 0.75)
        font.family: Style.font.family
        font.pixelSize: Style.font.body
      }
      Text {
        text: "> FOLLOW THE WHITE RABBIT."
        color: lock.withAlpha(Color.lock.text, 0.75)
        font.family: Style.font.family
        font.pixelSize: Style.font.body
      }
      Item { width: 1; height: 8 }
      Row {
        spacing: 6
        Text {
          text: lock.errorState ? "ACCESS DENIED" : "SYSTEM LOCKED"
          color: lock.errorState ? Color.lock.borderError : Color.lock.borderActive
          font.family: Style.font.family
          font.bold: true
          font.pixelSize: Style.font.heading
        }
        Rectangle {
          width: 13
          height: Style.font.heading
          color: Color.lock.borderActive
          anchors.verticalCenter: parent.verticalCenter
          SequentialAnimation on opacity {
            loops: Animation.Infinite
            NumberAnimation { from: 1; to: 0; duration: 1 }
            PauseAnimation { duration: 430 }
            NumberAnimation { from: 0; to: 1; duration: 1 }
            PauseAnimation { duration: 430 }
          }
        }
      }
      Item { width: 1; height: 4 }
      PasswordField {
        id: field
        lock: lock
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: 50
        radius: 4
        outlineThickness: 1
        color: Qt.rgba(0, 0, 0, 0.6)
        placeholder: "enter password"
      }
    }
  }
}
