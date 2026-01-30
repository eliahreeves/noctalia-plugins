import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets
import qs.Services.Location

// Bar Widget Component
Item {
  id: root

  property var pluginApi: null
  readonly property bool weatherReady: Settings.data.location.weatherEnabled && (LocationService.data.weather !== null)

  // Required properties for bar widgets
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""

  // Get settings or use false
  readonly property bool showTempText: pluginApi?.pluginSettings?.showTempText ?? false
  readonly property bool showConditionIcon: pluginApi?.pluginSettings?.showConditionIcon ?? false
  readonly property bool showTempLetter: pluginApi?.pluginSettings?.showTempLetter ?? false

  // Bar positioning properties
  readonly property string screenName: screen ? screen.name : ""
  readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
  readonly property bool isVertical: barPosition === "left" || barPosition === "right"
  readonly property real barHeight: Style.getBarHeightForScreen(screenName)
  readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)
  readonly property real barFontSize: Style.getBarFontSizeForScreen(screenName)

  readonly property real contentWidth: isVertical ? root.barHeight - Style.marginL : layout.implicitWidth + Style.marginL * 2
  readonly property real contentHeight: isVertical ? layout.implicitHeight + Style.marginS * 2 : Style.capsuleHeight

  visible: root.weatherReady
  opacity: root.weatherReady ? 1.0 : 0.0

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    color: root.hovered ? Color.mHover : Style.capsuleColor
    radius: !isVertical ? Style.radiusM : width * 0.5
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    Item {
      id: layout
      anchors.centerIn: parent

      implicitWidth: grid.implicitWidth
      implicitHeight: grid.implicitHeight

      GridLayout {
        id: grid
        columns: root.isVertical ? 1 : 2
        rowSpacing: Style.marginS
        columnSpacing: Style.marginS

            NIcon {
                visible: root.showConditionIcon
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                icon: weatherReady ? LocationService.weatherSymbolFromCode(LocationService.data.weather.current_weather.weathercode, LocationService.data.weather.current_weather.is_day) : "weather-cloud-off"
                applyUiScale: true
                color: root.hovered ? Color.mOnHover : Color.mOnSurface
            }

            NText {
                visible: root.showTempText
                text: {
                    if (!weatherReady || !root.showTempText) {
                        return "";
                    }
                    var temp = LocationService.data.weather.current_weather.temperature;
                    var suffix = "°C";
                    if (Settings.data.location.useFahrenheit) {
                        temp = LocationService.celsiusToFahrenheit(temp);
                        var suffix = "°F";
                    }
                    temp = Math.round(temp);
                    if (!root.showTempLetter) {
                        suffix = "";
                    }
                    return `${temp}${suffix}`;
                }
                color: root.hovered ? Color.mOnHover : Color.mOnSurface
                pointSize: root.barFontSize
                applyUiScale: true
            }
        }
    }
}

  // Mouse area to open panel
  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    onClicked: {
      if (pluginApi) {
        Logger.i("WeatherIndicator", "Opening Hello World panel");
      }
    }
  }
}
