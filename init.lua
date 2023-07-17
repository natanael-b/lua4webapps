local Pages = Pages
_ENV["Pages"] = nil

local function mkdir(path)
    -- Windows
    if package.config:sub(1,1) == "\\" then
        os.execute('md "'..path..'" >nul 2>nul')
        return
    end
    -- Any other OS in use since 2003
    os.execute("mkdir -p '"..path.."' >/dev/null 2>&1")
end

local original_ENV  = {}
local original_libs = {}
local original_meta = {}

for name,value in pairs(_ENV) do
    if type(value) == "table" then
        original_libs[name] = {}
        local lib = original_libs[name]
        for name, _value in pairs(value) do
            lib[name] = _value
        end

        original_meta[name] = {}
        lib = original_meta[name]
        for name, _value in pairs(getmetatable(value) or {}) do
            lib[name] = _value
        end
    else
        original_ENV[name] = value
    end
end

for i, page in original_ENV.ipairs(Pages) do
    print("Generating "..i.."/"..#Pages..": "..page..".html")

    original_ENV.setmetatable(_ENV,{})

    for variable in pairs(_ENV) do
        _ENV[variable] = nil
    end

    for name, fn in original_ENV.pairs(original_ENV) do
        _ENV[name] = fn
    end

    for name, lib in original_ENV.pairs(original_libs) do
        _ENV[name] = {}
        local newlib = _ENV[name]
        for name_, fn in pairs(lib) do
            newlib[name_] = fn
            original_ENV.setmetatable(newlib,nil)
        end
    end

    local directory = {Pages.output}
    for folder in original_libs.string.gmatch(page,"[^/]+") do
        directory[#directory+1] = folder
    end
    original_libs.table.remove(directory,#directory)

    local path = original_libs.table.concat(directory,"/")

    if path ~= "" then
        mkdir(path)
    end

    original_ENV.require "lua-wpp-framework.LuaTML"
    original_ENV.require (Pages.sources.."."..page:gsub("/","."))

    local html_file = original_libs["io"].open(Pages.output.."/"..page..".html","w")

    if html_file then
        html_file:write(type(__HTML__) == "string" and __HTML__ or "")
        html_file:close()
    end
end

print("Done :)")
