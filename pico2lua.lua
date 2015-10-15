#!/usr/bin/lua

if not arg[1] then

  print("Usage:\tpico2lua.lua [FILE]")
  print("Prints out the lua code in a file pico-8 format file to stdout.")
  print("e.g.: ./pico2lua.lua cart.p8 > code.lua")

else

  local file = io.open(arg[1])

  local found_lua = false
  local section_header = false
  while true do
    local line = file:read("*line")

    if line == nil then break end

    for section,_ in string.gmatch(line,"__(%a+)__") do
      section_header = true
      if section == "lua" then
        found_lua = true
        break
      else
        found_lua = false
        break
      end
    end

    if found_lua then
      if section_header then
        section_header = false
      else
        io.write(line.."\n")
      end
    end

  end

end
