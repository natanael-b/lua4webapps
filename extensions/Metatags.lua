

local title = _ENV[{}]
local metatable = getmetatable(title)

function metatable.__tostring(self)
   local title = ""
   for index, value in pairs(self) do
      for property, value in pairs(value) do
         title = tostring(value)
         goto break1
      end
      ::break1::
   end

  return '<meta property="og:title" content="'..title:gsub('"',"&quot;")..'" />'..
         '<title>'..title:gsub("<","&lt;")..'</title>'
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
              name="description",
              property="og:description"
            },
            bindings = {
               ['content'] = 'description',
            }
         },

         {
            element = meta {
              name="keywords"
            },
            bindings = {
               ['content'] = 'keywords',
            }
         },

         {
            element = meta {
               name="author"
            },
            bindings = {
               ['content'] = 'author',
            }
         },

         {
            element = meta {
               property="og:image"
            },
            bindings = {
               ['content'] = 'image',
            }
         },

         {
            element = meta {
               property="og:video"
            },
            bindings = {
               ['content'] = 'video',
            }
         },

         {
            element = meta {
               property="og:audio"
            },
            bindings = {
               ['content'] = 'audio',
            }
         },

         {
            element = meta {
               property="og:url"
            },
            bindings = {
               ['content'] = 'url',
            }
         },

         {
            element = title,
            bindings = {
               [1] = 'title',
            }
         },
      }
    }
 }