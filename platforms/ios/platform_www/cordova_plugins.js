cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/ru.appsm.customkeyboard/www/customkeyboard.js",
        "id": "ru.appsm.customkeyboard.customkeyboard",
        "pluginId": "ru.appsm.customkeyboard",
        "clobbers": [
            "window.CustomKeyboard"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.2.2",
    "ru.appsm.customkeyboard": "0.1.2"
}
// BOTTOM OF METADATA
});