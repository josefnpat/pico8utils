#!/usr/bin/lua

if not arg[1] or not arg[2] then

  print("Usage:\tlua2pico.lua [FILE.lua] [TARGET.p8]")
  print("Replaces the __lua__ section of the TARGET with the contents of FILE and then\nprints it to stdout.")
  print("e.g.: ./lua2pico.lua code.lua cart.p8 > new_cart.p8")

else

  local lua_file
  
  if arg[1] == '-' then
    lua_file = io.stdin
  else
    lua_file = io.open(arg[1])
  end

  local target_file = io.open(arg[2])

  local found_lua = false
  local lua_done = false
  local output_lua = false
  while true do
    local target_line = target_file:read("*line")

    if target_line == nil then break end

    for section,_ in string.gmatch(target_line,"__(%a+)__") do
      if section == "lua" then
        found_lua = true
        break
      else
        found_lua = false
        break
      end
    end

    if found_lua then
      if not lua_done then
        lua_done = true
        io.write("__lua__\n")
        while true do
          local lua_line = lua_file:read("*line")
          if lua_line == nil then break end
          io.write(lua_line.."\n")
        end
      end
    else
      io.write(target_line.."\n")
    end

  end

end
