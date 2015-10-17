#!/usr/bin/lua

-- Originally released under the the Romantic WTF Public License
-- Original version here:
-- http://getmoai.com/wiki/index.php?title=Concatenate_your_Lua_source_tree

args = {...}
fs = require"lfs"
files = {}

root = args[1]:gsub( "/$", "" )
              :gsub( "\\$", "" )

function scandir (root, path)
  -- adapted from http://keplerproject.github.com/luafilesystem/examples.html
  path = path or ""
  for file in fs.dir( root..path ) do
    if file ~= "." and file ~= ".." then
      local f = path..'/'..file
      local attr = lfs.attributes( root..f )
      assert (type( attr ) == "table")
      if attr.mode == "directory" then
        scandir( root, f )
      else
        if file:find"%.lua$" then
          hndl = (f:gsub( "%.lua$", "" )
                           :gsub( "/", "." )
                           :gsub( "\\", "." )
                           :gsub( "^%.", "" )
                         ):gsub( "%.init$", "" )
          files[hndl] = io.open( root..f ):read"*a"
        end
      end
    end
  end
end

scandir( root )

acc={"--This file was generated with pack.lua\n__package_preload={}\n"}

local wrapper = { "\n---file:\n__package_preload['"
                , nil, "'] = function (...)\n", nil, "\nend\n" }
for k,v in pairs( files ) do
  wrapper[2], wrapper[4] = k, v
  table.insert( acc, table.concat(wrapper) )
end

table.insert(acc, [[
--- require/dofile replacements

__package_load = {}

function assert(i,s)
  if not i then
    print(s)
    stop()
  end
end

function require(name)
  if not __package_load[name] then
    assert(__package_preload[name],"Error: module `"..name.."` does not exist.")
    __package_load[name] = __package_preload[name]()
  end
  return __package_load[name]
end

function dofile(name)
  local found
  for ppname,_ in pairs(__package_preload) do
    if name == ppname..".lua" then
      found = ppname
      break
    end
  end
  assert(__package_preload[found],"Error: file `"..found..".lua` does not exist.")
  return __package_preload[found]()
end
]])
if files.main then
  table.insert( acc, '\nrequire"main"' )
end
print( table.concat( acc ) )
