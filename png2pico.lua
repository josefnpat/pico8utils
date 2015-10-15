#!/usr/bin/luajit

local magick = require "magick"

_rgb_colors = {
  ["0,0,0"] = 0,
  ["29,43,83"] = 1,
  ["126,37,83"] = 2,
  ["0,135,81"] = 3,
  ["171,82,54"] = 4,
  ["95,87,79"] = 5,
  ["194,195,199"] = 6,
  ["255,241,232"] = 7,
  ["255,0,77"] = 8,
  ["255,163,0"] = 9,
  ["255,240,36"] = 10,
  ["0,231,86"] = 11,
  ["41,173,255"] = 12,
  ["131,118,156"] = 13,
  ["255,119,168"] = 14,
  ["255,204,170"] = 15,
}

function rgb2pico(r,g,b)
  return _rgb_colors[r..","..g..","..b]
end

if not arg[1] or not arg[2] then

  print("Usage:\tpico2png.lua [FILE.png] [TARGET.p8]")
  print("Replaces the __gfx__ section of the TARGET with the contents of FILE and then\nprints it to stdout.")
  print("e.g.: ./png2pico.lua spritesheet.png cart.p8 > new_cart.p8")

else

  local png_file,png_file_error = magick.load_image(arg[1])
  assert(png_file,png_file_error)
  local target_file = io.open(arg[2])

  local found_png = false
  local png_done = false
  local output_png = false
  while true do
    local target_line = target_file:read("*line")

    if target_line == nil then break end

    for section,_ in string.gmatch(target_line,"__(%a+)__") do
      if section == "gfx" then
        found_png = true
        break
      else
        found_png = false
        break
      end
    end

    if found_png then
      if not png_done then
        png_done = true
        io.write("__gfx__\n")
        for y = 0,127 do
          for x = 0,127 do
            local r,g,b = png_file:get_pixel(x,y)
            local pico_color = rgb2pico(
              math.floor(r*255),
              math.floor(g*255),
              math.floor(b*255))
            assert(pico_color,"Error: Input image contains invalid color")
            io.write(string.format("%x",pico_color))
          end
          io.write("\n")
        end
        io.write("\n")
      end
    else
      io.write(target_line.."\n")
    end

  end

end
