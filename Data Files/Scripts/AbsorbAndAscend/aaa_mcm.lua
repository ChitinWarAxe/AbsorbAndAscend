local I = require('openmw.interfaces')

I.Settings.registerPage {
    key = "AbsorbAndAscend",
    l10n = "AbsorbAndAscend",
    name = 'name',
    description = 'description'
}

I.Settings.registerGroup {
    key = "SettingsAbsorbAndAscend2",
    l10n = "AbsorbAndAscend",
    name = "aaaSettingsTitle2",
    page = "AbsorbAndAscend",
    description = "aaaSettingsDesc2",
    permanentStorage = false,
    settings = {
        {
            key = "aaaCustomKeyToggle",
            name = "aaaCustomKeyToggleName",
            description = "aaaCustomKeyToggleDesc",
            default = false,
            renderer = "checkbox"
        },
        {
            key = "aaaCustomKey1",
            name = "aaaCustomKey1Name",
            description = "aaaCustomKey1Desc",
            default = "H",
            renderer = "textLine"
        },
        {
            key = "aaaCustomKey2",
            name = "aaaCustomKey2Name",
            description = "aaaCustomKey2Desc",
            default = "B",
            renderer = "textLine"
        },
    }
}