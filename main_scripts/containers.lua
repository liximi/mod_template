--容器注册
local containers = require "containers"
local params = {}


--示例代码
-- params.container_prefab_name =  {
--     widget = {
-- 		slotpos = {
-- 			Vector3(-72,72,0),Vector3(0,72,0),Vector3(72,72,0),
-- 			Vector3(-72,0,0),Vector3(0,0,0),Vector3(72,0,0),
-- 			Vector3(-72,-72,0),Vector3(0,-72,0),Vector3(72,-72,0)
-- 		},
--         animbank = "bank_name",
--         animbuild = "build_name",
--         pos = Vector3(150, 30),
--     },
--     numslots = 9,
--     acceptsstacks = false,  --不接受堆叠物品
--     usespecificslotsforitems = false,
--     issidewidget = false,
--     openlimit = 1,          --只允许一个人打开
--     type = "sc_weapons_manager",
--     itemtestfn = function(inst, item, slot)
-- 		return true
--     end,
-- }



for prefabs, data in pairs(params) do
    containers.params[prefabs] = data
end