
function icons(sizes)
   local links = ""
   for size, uri in pairs(sizes) do
     for _, rel in ipairs {"icon","apple-touch-icon"} do
       links = links..tostring(link {rel=rel,type="image/png",sizes=(size.."x"..size),href=uri})
     end
   end
   return links
 end

local link = link
local metatable = getmetatable(link)
local link_tostring = metatable.__tostring
 
function metatable.__tostring(self)
   local has_href = false
   for index, value in pairs(self) do
      for property, value in pairs(type(value) == "table" and value or {}) do
         has_href = tostring(property):lower() == "href"
      end
   end 
   return has_href and link_tostring(self) or ""
 end

local meta = meta
local metatable = getmetatable(meta)
local meta_tostring = metatable.__tostring

function metatable.__tostring(self)
   local has_content = false
   for index, value in pairs(self) do
      for property, value in pairs(type(value) == "table" and value or {}) do
         has_content = tostring(property):lower() == "content"
      end
   end
  return has_content and meta_tostring(self) or ""
end

head = head:extends {
    childrens = {
      last = {
         {
            element = meta {
              name="mobile-web-app-capable",
              content="yes"
            }
         },
         {
            element = meta {
              name="apple-mobile-web-app-capable",
              content="yes"
            }
         },
         {
            element = meta {
              name="theme-color",
            },
            bindings = {
               ['content'] = 'theme_color',
            }
         },
         {
            element = meta {
              name="apple-mobile-web-app-status-bar-style",
            },
            bindings = {
               ['content'] = 'statusbar',
            }
         },
         {
            element = link {
              name="manifest",
              href="manifest.json"
            },
            bindings = {
               ['href'] = 'manifest',
            }
         },
      }
    }
 }