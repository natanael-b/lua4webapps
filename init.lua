require "lua-wpp-framework.LuaTML"

local Pages = Pages
_ENV["Pages"] = nil

for i, page in ipairs(Pages) do
    print("Generating "..i.."/"..#Pages..": "..page..".html")
    require (Pages.sources.."."..page:gsub("/","."))

    local html_file = io.open(Pages.output.."/"..page..".html","w")

    if html_file then
        html_file:write(__HTML__)
        html_file:close()
    end
end

print("Done :)")
