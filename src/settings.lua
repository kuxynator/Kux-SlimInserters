require("mod")
local extend = KuxCoreLib.SettingsData.extend
extend.prefix = mod.prefix

---@type KuxCorelib.Extend
local x

x = extend{"startup", "a"}
x:bool{"single-slim-inserter-enable", true}

x = extend{"startup", "b"}
x:bool{"double-slim-inserter-enable", true}

x = extend{"startup", "c"}
x:bool{"dual-slim-inserter-enable", true}


x = extend{"startup", "d"}
x:bool{"loader-slim-inserter-enable", true}

x = extend{"startup", "e"}
x:bool{"consume-vanilla-inserter", false}

x = extend{"startup", "z"}
x:bool{"debug-mode", false}

x = extend{"runtime-global", "z"}
x:bool{"runtime-debug-mode", false}

x = extend{"runtime-user", "a"}
x:bool{"dual-slim-inserter-mine-both", true}

