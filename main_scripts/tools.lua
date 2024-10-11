--工具函数

function _G.GetRandomPointRound(pt, radius)
	local rad = math.random() * math.pi * 2
	local r = math.random() * radius
	local offset_x = math.cos(rad) * r
	local offset_z = -math.sin(rad) * r
	return pt + Vector3(offset_x, 0, offset_z)
end

--[[检查一个坐标是否在给定的四边形内, 函数内没有做数据结构的检查, 请在调用前确保参数正确
    pos: {x = number, y = number}
    quad: table 按连续的顺序存入4个顶点的坐标({x = number, y = number})
]]
function _G.IsPointInsideConvexQuad(pos, quad)
    local side = nil
    for i = 1, 4 do
        local x1, y1 = quad[i].x, quad[i].y
        local next = i % 4 + 1
        local x2, y2 = quad[next].x, quad[next].y
        local curr_side = (x2 - x1) * (pos.y - y1) - (y2 - y1) * (pos.x - x1)
        if side == nil then
            side = curr_side
        elseif side * curr_side < 0 then
            return false
        end
    end
    return true
end

--[[获取一定半径内的所有地块的坐标]]
local tile_size = 4
function _G.GetTiles(x, z, radius)
	if radius == 0 then return {} end
	local tiles = {}
	local org = Vector3(x, 0, z)
	local org_tile_center = Vector3(TheWorld.Map:GetTileCenterPoint(x, 0, z))
	local org_offset = org - org_tile_center
	local top_count = math.ceil((org_offset.z + radius) / tile_size)
	local bottom_count = math.floor((org_offset.z - radius) / tile_size)
	local right_count = math.ceil((org_offset.x + radius) / tile_size)
	local left_count = math.floor((org_offset.x - radius) / tile_size)
	local radiusq = radius * radius

	for i = math.ceil(org_tile_center.x+left_count*tile_size), math.floor(org_tile_center.x+right_count*tile_size), 4 do
		for j = math.ceil(org_tile_center.z+bottom_count*tile_size), math.floor(org_tile_center.z+top_count*tile_size), 4 do
			local cur_pos = Vector3(i, 0, j)
			if org:DistSq(cur_pos) <= radiusq then
				table.insert(tiles, cur_pos)
			end
		end
	end

	return tiles
end

local hex_letters = {"A", "B", "C", "D", "E", "F"}
local function HexToString(hex)
	hex = math.floor(hex)
	if hex < 10 then
		return hex
	else
		return hex_letters[hex - 9]
	end
end
local spawned_uuids = {}
function _G.UUID()
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    local random = math.random
	local uuid
	while true do
		uuid = template:gsub("[xy]", function(c)
			local v = (c == "x") and random(0, 0xf) or random(8, 0xb)
			return HexToString(v)
		end)
		if not spawned_uuids[uuid] then
			spawned_uuids[uuid] = true
			break
		end
	end
    return uuid
end

function _G.Delete_UUID(id)
	if type(id) == "string" then
		spawned_uuids[id] = nil
	end
end


function _G.EncodePos(x, y, z)	--每个坐标预留了13位(坐标绝对值最大8191, 支出负数, 不支持小数)
	if type(x) == "table" then
		y = x.y or x[2]
		z = x.z or x[3]
		x = x.x or x[1]
	end
	local res = math.abs(z)
	if z < 0 then
		res = res + 8192
	end
	res = res + math.abs(y) * 16384
	if y < 0 then
		res = res + 134217728
	end
	res = res + math.abs(x) * 268435456
	if x < 0 then
		res = res + 2199023255552
	end
	return res
end

function _G.DecodePos(code)
	local z = code % 8192
	code = (code - z) / 8192
	local is_neg = code % 2
	if is_neg ~= 0 then
		z = -z
	end
	code = (code - is_neg) / 2

	local y = code % 8192
	code = (code - y) / 8192
	is_neg = code % 2
	if is_neg ~= 0 then
		y = -y
	end
	code = (code - is_neg) / 2

	local x = code % 8192
	code = (code - x) / 8192
	is_neg = code % 2
	if is_neg ~= 0 then
		x = -x
	end
	return x, y ,z
end

function _G.GetTileCenterPointByTileCoords(x, y)
	local size_x, size_y = TheWorld.Map:GetSize()
	return (x - math.ceil(size_x/2)) * 4 + 2, (y - math.ceil(size_y/2)) * 4 + 2
end

function _G.IsEmptyTable(tab)
	for k, v in pairs(tab) do
		return false
	end
	return true
end