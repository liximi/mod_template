--配方注册


--示例配方
-- AddRecipe2("prefab_name",
--     {Ingredient("cutstone", 2), Ingredient("genesis_living_stone", 2)},
--     TECH.SCIENCE_TWO,
--     {atlas = "images/inventoryimages/prefab_name.xml", image = "prefab_name.tex"},
--     {CRAFTING_FILTERS.GARDENING.name})

---------------------------------------------------
--料理配方
---------------------------------------------------

--示例配方
--花瓣和蕨叶可以入锅烹饪
--不可用作肉丸填充
--花瓣为0.25鲜花度
--蕨叶为0.25蕨叶度 0.25菜度
-- AddIngredientValues({"petals"}, {petals = 0.25}, false, false)
-- AddIngredientValues({"foliage"}, {foliage = 0.25, veggie = 0.25}, false, false)

-- local foods = require "genesis_food_defs"
-- for name, cook_recipe in pairs(foods) do
-- 	AddCookerRecipe("cookpot", cook_recipe)				--添加到普通锅
-- 	AddCookerRecipe("portablecookpot", cook_recipe)		--添加到便携锅
-- end