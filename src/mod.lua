KuxCoreLib = require("__Kux-CoreLib__/lib/init") --[[@as KuxCoreLib]]

_G.mod={
	name="Kux-SlimInserters",
	path = "__Kux-SlimInserters__/",
	prefix="Kux-SlimInserters_",
}

Events = KuxCoreLib.Events.asGlobal()
ErrorHandler = KuxCoreLib.ErrorHandler.asGlobal()
Trace = KuxCoreLib.Trace.asGlobal()
Trace.prefix_sign = "▶"
Trace.sign_color = Trace.colors.yellow
Trace.text_color = Trace.colors.darkyellow

return mod
