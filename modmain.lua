GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {}

Assets = {}


--[Localization]
local mod_loc_files = { 	--本mod的所有本地化文件名(不含语种前缀)
    "common",				--无法归类或没必要归类的文本
    "ui",             		--界面相关文本
}
local user_setting_mapping = {  --Mod设置到本地化文件前缀的映射
    CHINESE = "chinese",
    ENGLISH = "english",
}
local user_setting_lan = GetModConfigData("language")       --读取Mod语言自定义设置
local loc = require "languages/loc"
local lan = loc and loc.GetLanguage and loc.GetLanguage()   --读取玩家的客户端语言设置
local prefix = user_setting_mapping[user_setting_lan]   --Mod设置生效
if not prefix then  --如果没有找到匹配的文件前缀，则使用默认的前缀：中文是chinese，其他的都是english
    if lan == LANGUAGE.CHINESE_S or lan == LANGUAGE.CHINESE_S_RAIL then
        prefix = "chinese"
    else
        prefix = "english"
    end
end

for _, f_name in ipairs(mod_loc_files) do
    modimport("scripts/localization/"..prefix.."_"..f_name)	--加载所有本地化文件
end

--[Constants]
modimport "main_scripts/constants"
--[Tools]
modimport "main_scripts/tools"
--[Containers]
modimport "main_scripts/containers"
--[RPCs]
modimport "main_scripts/rpcs"
--[UI]
modimport "main_scripts/ui"
--[Actions]
modimport "main_scripts/actions"
--[StateGraphs]
modimport "main_scripts/stategraphs"
-- [配方]
modimport "main_scripts/recipes"

--[replica组件注册]
-- AddReplicableComponent("replica_component_name")

--注册地图图标
-- AddMinimapAtlas("images/minimap/xxx_mini.xml")


--------------------------------------------------
-- [本MOD针对游戏本体的修改内容]
--------------------------------------------------

local mod_files = {
    -- "file_name",
}

for _, file in ipairs(mod_files) do
    modimport("main_scripts/modified_mechanics/"..file)
end