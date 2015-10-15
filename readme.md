#PICO-8 UTILS

This is a set of utilities made for the `.p8` [PICO-8](http://www.lexaloffle.com/pico-8.php) file format.

They were written against Lua 5.3, but will most likely run correctly against Lua 5.x.

All of these scripts were made with the unix philosophy.

For pico2png and png2pico, you need to use luajit and have imagemagick installed.

##Example usage:

__these examples include backup__

Update `foo.v8`'s Lua code with `foo.lua`:

`cp foo.lua foo.backup.lua && lua ./png2pico.lua foo.lua foo.backup.v8 > foo.v8`

Update `foo.v8`'s spritesheet gfx with `foo.png`:

`cp foo.v8 foo.backup.v8 && luajit ./png2pico.lua foo.png foo.backup.v8 > foo.v8`

Extract `foo.v8`'s Lua code from `foo.v8`:

`lua ./pico2lua.lua foo.v8 > foo.lua`

Extract `foo.v8`'s gfx as a png from `foo.v8`:

`lua ./pico2png.lua foo.v8 > foo.png`