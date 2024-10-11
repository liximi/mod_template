--[[ MOD打包脚本 By liximi ]]

--将只需要上传发布的MOD文件单独复制到脚本所在文件夹的指定子文件夹中，用于发布
--依赖lfs库
--必须将该脚本放在MOD文件夹中运行
--路径以MOD文件夹为根目录
--如果要导出一整个子文件夹，则只需填写文件夹名称
--所有路径以"/"作为分隔符
--通过在文件夹后面加{文件格式1,文件格式2}来指定要导出的文件的格式，不要留空格
local output_path = "output"    --导出目标子文件夹名称
local export_files = {          --要导出的所有文件
    "modmain.lua",
    "modinfo.lua",
    "modicon.tex",
    "modicon.xml",
    "scripts",
    "anim",
    "bigportraits{tex,xml}",
    "images{tex,xml}",
    "main_scripts",
    "readme.md"
}
local modinfo_override = {      --modinfo属性覆写，不需要修改的属性就注释掉, key和value都只支持字符串类型
    version = "1.0.0",
}


---------------------------------------------------------------------

local lfs = require "lfs"
assert(lfs, "require lfs failed")
print(lfs._VERSION.."\n"..lfs._COPYRIGHT.."\n")

local function DoFnForAllFile(folder_path, fn_file, fn_folder)
    for file in lfs.dir(folder_path) do
        if file ~= "." and file ~= ".." then
            local path = folder_path.."/"..file
            local attr = lfs.attributes(path)
            if attr.mode == "directory" and file ~= output_path then
                fn_folder(path)
                DoFnForAllFile(path, fn_file, fn_folder)
            elseif attr.mode == "file" then
                fn_file(path)
            end
        end
    end
end

local function DeleteAllFile(folder_path)
    for file in lfs.dir(folder_path) do
        if file ~= "." and file ~= ".." then
            local attr = lfs.attributes(folder_path.."/"..file)
            if attr.mode == "directory" and file ~= output_path then
                DeleteAllFile(folder_path.."/"..file)
                lfs.rmdir(folder_path.."/"..file)
            elseif attr.mode == "file" then
                os.remove(folder_path.."/"..file)
            end
        end
    end
    lfs.rmdir(folder_path)
end


---------------------------------------------------------------------


print("start >")
local currentdir = lfs.currentdir()
print("Current path: \""..currentdir.."\"\n")


DeleteAllFile(output_path)      --移除之前的导出文件夹
lfs.mkdir(output_path)          --创建导出文件夹

local function OutputFolder(folder_path, export_format)
    export_format = export_format and string.sub(export_format, 2, #export_format - 1)
    local formats = {}
    if export_format then
        local i = 0
        while i < #export_format do
            local comma_pos = string.find(export_format, ",", i)
            local format = ""
            if comma_pos then
                format = string.sub(export_format, i, comma_pos - 1)
                i = comma_pos + 1
            else
                format = string.sub(export_format, i)
                i = #export_format
            end
            table.insert(formats, format)
        end
    end

    DoFnForAllFile(folder_path,
    function(source_path)
        if export_format then
            local can_export = false
            for _, format in ipairs(formats) do
                if format == string.sub(source_path, -#format, -1) then
                    can_export = true
                    break
                end
            end
            if not can_export then return end
        end

        local source_file = io.open(source_path, "rb")
        if source_file then
            local data = source_file:read("*a")
            source_file:close()

            local p = string.match(source_path, "/.*") or ""
            local try_open = io.open(currentdir.."/"..output_path..p, "r")
            if try_open then
                print("  > File already exported".." ["..p.."]")
                try_open:close()
                return
            end
            local new_file = io.open(currentdir.."/"..output_path..p, "w+b")
            if new_file then
                new_file:write(data)
                new_file:close()
                print("  > "..p)
            else
                print("  > Can not output file ".." ["..p.."]")
            end
        end
    end,
    function(_path)
        local p = string.match(_path, "/.*") or ""
        local success, reson = lfs.mkdir(currentdir.."/"..output_path..p)
        if success then
            print("  > "..p)
        else
            print("  > "..tostring(reson).." ["..p.."]")
        end
    end)
end

for _, relative_path in ipairs(export_files) do
    local export_format = string.match(relative_path, ".*({.*})")
    relative_path = string.match(relative_path, "(.*)"..(export_format or ""))
    local source_path = currentdir.."/"..relative_path
    local attr = lfs.attributes(source_path)
    if attr then
        if attr.mode == "directory" then
            local temp_p = ""
            for folder in string.gmatch(relative_path, ".-/") do
                temp_p = temp_p..folder
                lfs.mkdir(output_path.."/"..temp_p)
            end
            local success, reson = lfs.mkdir(output_path.."/"..relative_path)
            if success then
                print("> "..relative_path)
                OutputFolder(source_path, export_format)
            else
                print("> "..tostring(reson).." ["..relative_path.."]")
            end
        elseif attr.mode == "file" then
            local relative_folder_path = string.match(relative_path, ".*/")
            if relative_folder_path then
                lfs.mkdir(output_path.."/"..relative_folder_path)
            end

            local source_file = io.open(source_path, "rb")
            if source_file then
                local data = source_file:read("*a")
                source_file:close()

                local output_file = io.open(output_path.."/"..relative_path, "w+b")
                if output_file then
                    output_file:write(data)
                    output_file:close()
                    print("> "..relative_path)
                end
            end
        end
    else
        print("> Can not find file/folder ["..relative_path.."]")
    end
end

print("[Override Modinfo]")
local modinfo_path = output_path.."/modinfo.lua"
local modinfo_file = io.open(modinfo_path, "r")
if modinfo_file then
    local content = modinfo_file:read("*a")
    for key, val in pairs(modinfo_override) do
        print("  "..key.." = "..tostring(val))
        local pattern = key..'%s*=%s*"[^"]+"[^,]'
        if not string.match(content, pattern) then
            print("    Not Find Key: "..key)
        end
        content = string.gsub(content, pattern, key..' = "'..val..'"\n')
    end
    modinfo_file:close()
    modinfo_file = io.open(modinfo_path, "w+")
    modinfo_file:write(content)
    modinfo_file:close()
else
    print("Not Find ModInfo File: "..modinfo_path)
end


print("\ndone :)\n")