# readme

声明：本饥荒Mod项目模板只是来自个人在开发过程中的习惯，用于快速创建一个可以支撑一定体量项目的文件结构，并不是每个地方都能符合任意项目，请自行判断是否适用。

## 删除占位文件

`exported`文件夹下的名字为`1`的文件可以直接删除，`images`路径下的名字为`1`的文件可以直接删除。

## main_scripts

`main_scripts`路径下的文件的作用是将原本需要写在 `modmain.lua`里面的代码拆分到其他文件中进行管理，避免 `modmain`的内容过于庞大导致不便于管理。

1. 需要修改 `main_scripts`文件夹的名称，通常只需要增加你的mod的特殊前缀即可，例如：`mymod_main_scripts`。
2. 需要将 `modmain.lua`里面的引用路径从 `main_scripts`改为你修改后的路径。
3. `main_scripts`路径下不需要的内容可以删除，记得删除 `modmain.lua`里对应的引用。

```lua
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
--------------------------------------------------
-- [本MOD针对游戏本体的修改内容]
--------------------------------------------------
local mod_files = {
    -- "file_name",
}
for _, file in ipairs(mod_files) do
    modimport("main_scripts/modified_mechanics/"..file)
end
```

## 贴图管理建议

1. 图片的源文件建议只存放在 `art_assets`文件夹里，防止自动打包覆盖特殊处理过的图片。`images`路径下只放 `tex`和 `xml`格式的文件。
2. `art_assets`文件夹里的文件路径与 `images`目录下需要的图片文件夹路径一致。
3. `art_assets`文件夹里也可以存放其他美术资源的源文件，比如modicon、角色立绘等。格式也不限于图片，ps、sai源文件也可以塞到里面。
4. `art_assets`里的 `mergePng2Tex&Xml.exe`是用于合并贴图的工具，同类型的或紧密相关的贴图应该尽可能合并到一个tex中，减少tex数量。（你也可以使用自己习惯的工具）

## 多语言文本管理

1. `modmain`中已经添加了这部分功能的代码，`modinfo`中也默认添加了语言设置，你可以根据自己的需求修改或删除对应的代码。
2. 如果你要使用本模板提供的多语言文本管理方案，那么你只需要在 `scripts/localization/`这个路径下添加你的多语言文本。
3. 简答来说，本模板通过固定的文件名来读取不同语言的文件，比如中文使用 `chinese`作为前缀，你可以看到默认已经存在2个文件：`chinese_common.lua`和 `chinese_ui.lua`，他们里面应该用来添加中文文本，`common`文件中添加一般性文本，比如角色名称等，而 `ui`文件中则添加UI中使用的文本，如果你的mod没有UI，则可以删除这个文件。
4. 新增/删除多语言文件都需要对应的修改 `modmain`里面的代码

```lua
--[Localization]
local mod_loc_files = {  --本mod的所有本地化文件名(不含语种前缀)
    "common",  --无法归类或没必要归类的文本
    "ui",  --界面相关文本
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
```

## 导出发布

使用根目录下的 `packing.lua`脚本导出要发布的Mod包体，这是为中大型Mod准备的发布流程。由于Mod项目里可能会掺杂较多不能上传的源文件和无关文件，或存在一些特殊路径需要上传，因此手动复制出一个包体比较麻烦。因此有了这套自动打包流程。

1. 发布/更新版本号在 `packing.lua`脚本里配置，开发版始终使用 `dev`作为版本号，不去修改，这样可以在代码中通过判定mod版本号插入一些debug代码，而不用在上传前去专门改代码。
2. 发布之前最好先在本地测试一次导出的Mod包，除了Mod内容外，还需要检查**Mod名称**和**Mod本版号**

## 使用Git

推荐使用 `Git`来管理你的项目，并且本模板已经准备了一份基础的 `.gitignore`文件，排除了不需要同步的文件。

这份基础的 `.gitignore`文件中包含了anim路径，因为不推荐同步anim路径下的动画包，通常它们都可以在各个开发者自己的电脑上自动生成。

## 总结

总的来说，本模板的风格是将和一个mod相关的所有资产都放在mod文件夹中进行管理，各个协作开发者之间利用Git同步资产（美术、声音、设计案和代码）并进行版本管理，最终使用自动打包脚本导出要发布的内容。
