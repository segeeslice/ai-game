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

-- e.g. logBase(4, 2) = 2
-- Based on principle that logb(a) = logc(a) / logc(b)
function logBase(num, base)
  return math.log(num) / math.log(base)
end

-- Find the nth root of some method
-- https://rosettacode.org/wiki/Nth_root#Lua
function nRoot(num, root)
  return math.pow(num, 1/root)
end

-- Namespace for easier code tracing
utils = {
  copy = copy,
  logBase = logBase,
  nRoot = nRoot
}
