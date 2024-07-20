local I = require('openmw.interfaces')

I.Settings.registerGroup {
    key = "SettingsAbsorbAndAscend1",
    l10n = "AbsorbAndAscend",
    name = "aaaSettingsName1",
    page = "AbsorbAndAscend",
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