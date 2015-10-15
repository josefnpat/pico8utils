#!/usr/bin/luajit

local magick = require "magick"

-- This following code is a big dirty hack that uses os.execute and imagemagick's
-- convert to allow for the `new_image` and `set_pixel` functions.
-- I would normally expect these to exist, but they don't right now.

-- TODO: ask leafo to extend magick library
__tmp = '/tmp/pico2png.temp.png'
function new_image(w,h)
  os.execute('convert -size '..w.."x"..h..' xc:white '..__tmp)
  local png,err = magick.load_image(__tmp)
  return png,err
end
__points = {}
__count = 0
function set_pixel(x,y,r,g,b)
  table.insert(__points,"fill rgb("..r..","..g..","..b..") point "..x..","..y.." ")
  if __count > 2^12 then
    __flush_pixels()
    __count = 0
  end
  __count = __count + 1
end
function __flush_pixels()
  os.execute("convert -draw '"..table.concat(__points).."' "..__tmp.." "..__tmp)
  __points = {}
end
function __post()
  __flush_pixels()
  return magick.load_image(__tmp)
end

_rgb_colors = {
  ["0"] = {0,0,0},
  ["1"] = {29,43,83},
  ["2"] = {126,37,83},
  ["3"] = {0,135,81},
  ["4"] = {171,82,54},
  ["5"] = {95,87,79},
  ["6"] = {194,195,199},
  ["7"] = {255,241,232},
  ["8"] = {255,0,77},
  ["9"] = {255,163,0},
  ["a"] = {255,240,36},
  ["b"] = {0,231,86},
  ["c"] = {41,173,255},
  ["d"] = {131,118,156},
  ["e"] = {255,119,168},
  ["f"] = {255,204,170},
}

function pico2rgb(pico)
  return _rgb_colors[pico]
end

if not arg[1] then

  print("Usage:\tpico2png.lua [FILE]")
  print("Prints out the pico-8 gfx code in png format file to stdout.")
  print("e.g.: ./tpico2png.lua cart.p8 > spritesheet.png")

else

  local file = io.open(arg[1])

  local png = new_image(128,128)
  local x,y = 0,0

  local found_lua = false
  local section_header = false

  while true do
    local line = file:read("*line")

    if line == nil then break end

    for section,_ in string.gmatch(line,"__(%a+)__") do
      section_header = true
      if section == "gfx" then
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

        for x = 1, #line do
          local c = line:sub(x,x)
          local rgb_color = pico2rgb(c)
          assert(rgb_color,"Error: Input gfx contains invalid color")
          set_pixel(x-1,y,rgb_color[1],rgb_color[2],rgb_color[3])
        end

        y = y + 1

      end
    end

  end

  -- TODO: remove once hacks are removed
  png = __post()
  print(png:get_blob())

end
