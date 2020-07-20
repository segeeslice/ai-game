-- Utility methods, primarily implementing things that Lua doesn't natively

-- Copy an object by value to a new object
-- https://gist.github.com/tylerneylon/81333721109155b2d244
function copy(obj, seen)
  -- Handle non-tables and previously-seen tables.
  if type(obj) ~= 'table' then return obj end
  if seen and seen[obj] then return seen[obj] end

  -- New table; mark it as seen an copy recursively.
  local s = seen or {}
  local res = {}
  s[obj] = res
  for k, v in next, obj do res[copy(k, s)] = copy(v, s) end
  return setmetatable(res, getmetatable(obj))
end

-- Namespace for easier code tracing
utils = {
  copy = copy
}
