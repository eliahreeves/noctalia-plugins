import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root

  property var pluginApi: null

  property bool showTempText: pluginApi?.pluginSettings?.showTempText ?? false
  property bool showConditionIcon: pluginApi?.pluginSettings?.showConditionIcon ?? false
  property bool showTempLetter: pluginApi?.pluginSettings?.showTempLetter ?? false

  spacing: Style.marginL

  Component.onCompleted: {
    Logger.i("WeatherIndicator", "Settings UI loaded");
  }

  NToggle {
    id: toggleIcon
    label: pluginApi?.tr("settings.showConditionIcon.label") || "showConditionIcon"
    description: pluginApi?.tr("settings.showConditionIcon.desc") || "Show the condition icon"
    checked: root.showConditionIcon
    onToggled: checked => {
      root.showConditionIcon = checked;
      root.showTempText = true;
    }
  }

  NToggle {
    id: toggleTempText
    label: pluginApi?.tr("settings.showTempText.label") || "showTempText"
    description: pluginApi?.tr("settings.showTempText.desc") || "Show the temperature"
    checked: root.showTempText
    onToggled: checked => {
      root.showTempText = checked;
      root.showConditionIcon = true;
    }
  }

  NToggle {
    id: toggleTempLetter
    label: pluginApi?.tr("settings.showTempLetter.label") || "showTempLetter"
    description: pluginApi?.tr("settings.showTempLetter.desc") || "Show temperature letter (°F or °C)"
    checked: root.showTempLetter
    visible: root.showTempText
    onToggled: checked => {
      root.showTempLetter = checked;
    }
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("WeatherIndicator", "Cannot save settings: pluginApi is null");
      return;
    }

    pluginApi.pluginSettings.showTempText = root.showTempText;
    pluginApi.pluginSettings.showConditionIcon = root.showConditionIcon;
    pluginApi.pluginSettings.showTempLetter = root.showTempLetter;

    pluginApi.saveSettings();

    Logger.i("WeatherIndicator", "Settings saved successfully");
    pluginApi.closePanel(root.screen);
  }
}
