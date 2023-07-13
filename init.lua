require "lua-wpp-framework.LuaTML"

local function mkdir(output,path)
    -- Windows
    if package.config:sub(1,1) == "\\" then
        os.execute('md "'..output.."/"..table.concat(path,"/",1,#path-1)..'" >nul 2>nul')
        return
    end
    -- Any other OS in use since 2003
    os.execute("mkdir -p '"..output.."/"..table.concat(path,"/",1,#path-1).."' >/dev/null 2>&1")
end

local Pages = Pages
_ENV["Pages"] = nil

for i, page in ipairs(Pages) do
    print("Generating "..i.."/"..#Pages..": "..page..".html")

    local path = {}
    for dir in page:gmatch("[^/]+") do
        path[#path+1] = dir
    end
    
    if #path > 1 then
        mkdir(Pages.output,path)
    end

    require (Pages.sources.."."..page:gsub("/","."))

    local html_file = io.open(Pages.output.."/"..page..".html","w")

    if html_file then
        html_file:write(type(__HTML__) == "string" and __HTML__ or "")
        html_file:close()
    end
end

print("Done :)")
