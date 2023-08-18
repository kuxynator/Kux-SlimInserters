require("mod")

data:extend {
	{
		type = "bool-setting",
		name = "Kux-SlimInserters_debug-mode",
		setting_type = 'startup',
		default_value = false,
	},
	{
		type = "bool-setting",
		name = "Kux-SlimInserters_runtime-debug-mode",
		setting_type = 'runtime-global',
		default_value = false,
		localised_name = "Debug Mode",
		localised_description = "If enabled some exta code is executed to help debugging. e.g. print information to console/log. This mode affects the performance somewhat and should be activated only when needed",
	},
}
