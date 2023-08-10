require("mod")

data:extend {
	{
		type = "bool-setting",
		name = "Kux-SlimInserters_debug-mode",
		setting_type = 'startup',
		default_value = false,
		localised_name = "Debug Mode",
		localised_desscription = "If enabled some exta code is executed to help debugging. e.g. print information to console/log. This mode affects the performance somewhat and should be activated only when needed",
	},
	{
		type="string-setting",
		setting_type = 'startup',
		name="slim-inserter-platform-picture",
		allowed_values={"arrow", "arrow -line"},
		default_value = "arrow",
		localised_name = "Platform Picture",
	},
	{
		type = "bool-setting",
		name = "Kux-SlimInserters_runtime-debug-mode",
		setting_type = 'runtime-global',
		default_value = false,
		localised_name = "Debug Mode",
		localised_desscription = "If enabled some exta code is executed to help debugging. e.g. print information to console/log. This mode affects the performance somewhat and should be activated only when needed",
	},
}
