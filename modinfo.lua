local chinese = locale == "zh" or locale  == "zhr"

name = chinese and "Mod模板" or "Mod Template"
description = chinese and "这是一个Mod模板。" or "This is a Mod Template."
author = "liximi"
version = "dev"

forumthread = ""

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true
all_clients_require_mod=true

api_version = 10
priority = 0

icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {} --服务器标签可以不写

configuration_options = {
    {
        name = "language",
        label = chinese and "语言" or "Language",
        hover = chinese and "设置语言" or "Set Language",
        options = {
            {description = "English", data = "ENGLISH"},
            {description = "中文", data = "CHINESE"},
            {description = "Auto/自动", data = "AUTO"}
        },
        default = "AUTO",
    },
}