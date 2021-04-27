--[[
--Any and all general inheritance-related methods
--Great help from:
--http://lua-users.org/wiki/InheritanceTutorial
--]]

function _inheritFrom (baseClass)
  -- Initialize new class with central meta table
  local newClass = { super=baseClass }
  local classMt = { __index = newClass }

  -- Create generic creation method
  function newClass:create(obj)
    local instance = obj or {}
    setmetatable(instance, classMt)
    return instance
  end

  -- Perform inheritance
  if baseClass ~= nil then
    setmetatable(newClass, { __index = baseClass })
  end

  return newClass
end

-- Export in traceable way
inherit = {
  from = _inheritFrom
}
