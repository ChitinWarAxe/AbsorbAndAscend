local I = require('openmw.interfaces')

I.Settings.registerGroup {
    key = "SettingsAbsorbAndAscend",
    l10n = "AbsorbAndAscend",
    name = "settingsTitle",
    page = "AbsorbAndAscend",
    description = "settingsDesc",
    permanentStorage = false,
    settings = {
        {
            key = "aaaToggle",
            name = "aaaToggleName",
            description = "aaaToggleDesc",
            default = true,
            renderer = "checkbox"
        },
        {
            key = "aaaProtectedItems",
            name = "aaaProtectedItemsName",
            description = "aaaProtectedItemsDesc",
            default = "sunder, keening, wraithguard",
            renderer = "textLine"
        }
    }
}