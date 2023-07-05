local _ENV_metatable = getmetatable(_ENV) or {}

_PROMPT = _ENV["_PROMT"] or "> "  -- Prevent from changing prompt on interactive mode

__JAVASCRIPT__ = ""

function _ENV_metatable.__index (self,name)
  local content = rawget(self,name)

  if content ~= nil then
    return content
  end

  return setmetatable({tag=name}, {
    __mul =
      function (self,number)
        local block = {}

        for i = 1, number do
          block[#block+1] = self
        end

        return setmetatable(block, {
          __tostring =
            function (self)
              local result = ""
              for i, element in ipairs(self) do
                result = result..tostring(element)
              end
              return result
            end
        })
      end
    ;

    __pow =
      function (self,items)
        local block = {}

        items = type(items) == "table" and items or {items}

        for i, item in ipairs(items) do
          local element = {tag = self.tag,properties = {}}
          for property, value in pairs(self.properties or {}) do
            element.properties[property] = value
          end
          element = setmetatable(element,getmetatable(self))
          element.properties[1] = tostring(item)
          block[#block+1] = element
        end

        return setmetatable(block, {
          __tostring =
            function (self)
              local result = ""
              for i, element in ipairs(self) do
                result = result..tostring(element)
              end
              return result
            end
        })
    end,

    __tostring =
      function (self)
        local html = "<"..self.tag
        
        self.properties = self.properties or {}

        if self.tag:lower() == "head"  then
          if _ENV["DISABLE_UTF8"] ~= true then
            self.properties[#self.properties+1] = meta { charset="utf8" }
          end

          if _ENV["DISABLE_VIEWPORT"] ~= true then
            self.properties[#self.properties+1] = meta {
                                                         name="viewport",
                                                         content="width=device-width,initial-scale=1.0"
                                                       }
          end

          if type(__JAVASCRIPT_FILE__) == "string" then
            self.properties[#self.properties+1] = script {
              scr=__JAVASCRIPT_FILE__
            }
          end
        end

        for property, value in pairs(self.properties or {}) do
          if type(property) ~= "number" then
            if type(value) and getmetatable(value) == nil and property:sub(1,2) == "on" then
              if type(__JAVASCRIPT__) == "string" then
                local old_uuid = tostring(UniqueID)
                self.id = tostring(self.properties.id or UniqueID())
                rawset(UniqueID,"value",old_uuid)

                local function_name = "when_"..property:sub(3,-1).."_on_"..self.id.."()"
                __JAVASCRIPT__ = __JAVASCRIPT__.."\n\nfunction "..function_name.." {\n  "..table.concat(value,";\n  ").."\n}"
                value = function_name..";"
              else
                  value = table.concat(value,";"):gsub("\"","&quot;")
              end
              
            end
          html = html.." "..property.."=\""..value:gsub("\"","&quot;").."\""
          end
        end

        if (#(self.properties or {}) == 0) and self.tag:lower() ~= "script" and self.tag:lower() ~= "html" then
          return html.."/>"
        end

        html = html..">"

        for i, children in ipairs(self.properties or {}) do
          html = html..tostring(children)
        end

        if self.tag:lower() == "body" and __JAVASCRIPT__ ~= "" then
          html = html..tostring(script("\n"..__JAVASCRIPT__.."\n\n"))
        end

        return html.."</"..self.tag..">"
      end
    ;

    __call =
      function (self,properties)
        self.properties = type(properties) == "table" and properties or {tostring(properties)}

        if self.tag:lower() == "html" then
          __HTML__ = tostring("<!DOCTYPE html>"..tostring(self))
          return __HTML__
        end

        return self
      end
    ;
  })
end

setmetatable(_ENV,_ENV_metatable)

UniqueID = {}
UniqueID = setmetatable(UniqueID,{
  __index = UniqueID,
  __call =
    function (self)
      local result = ""
      for i=1,9 do
        if math.random(1,2) == 1 then
          result = result..string.char(math.random(97, 97 + 25))
        else
          result = result..string.char(math.random(65, 65 + 25))
        end
      end
      self.value = result
      return self
    end
  ;
  __tostring =
    function (self)
      return self.value
    end
  ;
})

UniqueID()
