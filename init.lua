local Pages = Pages
_ENV["Pages"] = nil

local Extensions = Extensions
_ENV["Extensions"] = nil

local Extension_Pages = {}

local Registered_Extensions = {}

local function clone_table(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[clone_table(orig_key)] = clone_table(orig_value)
        end
        setmetatable(copy, clone_table(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

-- Remove recursive references
_G = nil
package.loaded._G = nil
package.loaded.package = nil

-- Remove the _ENV metatable te ensure that onle LuaWPP metatable will be loaded

setmetatable(_ENV,nil)

-- Clone the global variable state 

local __ENV  = clone_table(_ENV)
local __loadedpackage  = clone_table(package.loaded)

local function dirname(name)
    local directory = {Pages.output}
    for folder in __ENV.string.gmatch(name,"[^/]+") do
        directory[#directory+1] = folder
    end
    __ENV.table.remove(directory,#directory)

    return __ENV.table.concat(directory,"/")
end

local function mkdir(path)
    local path = dirname(path)
    -- Windows
    if package.config:sub(1,1) == "\\" then
        os.execute('md "'..path..'" >nul 2>nul')
        return
    end
    -- Any other OS in use since 2003
    os.execute("mkdir -p '"..path.."' >/dev/null 2>&1")
end


for i, page in __ENV.ipairs(Pages) do
    print("Generating "..i.."/"..#Pages..": "..page..".html")
    mkdir(page)

    __ENV.setmetatable(_ENV,nil)

    for key, value in ipairs(clone_table(__ENV)) do
        _ENV[key] = value
    end

    -- Unload LuaWPP libraries
    for pkg in pairs(package.loaded) do
        if __loadedpackage[pkg] == nil then
            package.loaded[pkg] = nil
        end
    end

    require "lua-wpp-framework.LuaTML"

    for i, name in ipairs(Extensions or {}) do
        require("lua-wpp-framework.extensions."..name)
        if Registered_Extensions["lua-wpp-framework.extensions."..name] == nil then
            Registered_Extensions["lua-wpp-framework.extensions."..name] = true
        end

        if RegisterPlugin then
            RegisterPlugin(Extension_Pages)
        end
        
        RegisterPlugin = nil
    end
    
    require(Pages.sources.."."..page:gsub("/","."))

    local html_file = __ENV.io.open(Pages.output.."/"..page..".html","w")

    if html_file then
        html_file:write(type(__HTML__) == "string" and __HTML__ or "")
        html_file:close()
    end
end

for filename, content in pairs(Extension_Pages) do
    mkdir(filename)

    local html_file = __ENV.io.open(Pages.output.."/"..filename,"w")

    if html_file then
        html_file:write(tostring(content or ""))
        html_file:close()
    end
end

print("Done :)")
