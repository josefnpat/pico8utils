#PICO-8 UTILS

This is a set of utilities made for the 0.1.2 `.p8` [PICO-8](http://www.lexaloffle.com/pico-8.php) file format.

They were written against Lua 5.3, but will most likely run correctly against Lua 5.x.

All of these scripts were made with the unix philosophy.

For `pico2png.lua` and `png2pico.lua`, you need to use luajit, magick (`luarocks install magick`) and have imagemagick installed.

For `pack.lua`, you need to have lfs installed (`luarocks install luafilesystem`)

##Example usage:

Extract `foo.p8`'s Lua code from `foo.p8`:

`lua ./pico2lua.lua foo.p8 > foo.lua`

Extract `foo.p8`'s gfx as a png from `foo.p8`:

`lua ./pico2png.lua foo.p8 > foo.png`

__these examples include backup__

Update `foo.p8`'s Lua code with `foo.lua`:

`cp foo.lua foo.backup.lua && luajit ./png2pico.lua foo.lua foo.backup.p8 > foo.p8`

Update `foo.p8`'s spritesheet gfx with `foo.png`:

`cp foo.p8 foo.backup.p8 && luajit ./png2pico.lua foo.png foo.backup.p8 > foo.p8`

##Dependencies

While some of these scripts can use any `5.x` version of `lua`, the ones dependent on `magick` requires `luajit` (which is the drop in for `5.1`).

If you have instructions for an OS that is not listed here, please open an issue with instructions or make a pull request.

### Linux (Arch)

```
sudo pacman -S lua51 luajit luarocks5.1
sudo luarocks-5.1 install magick
luarocks-5.1 list
cd /path/to/repo
```

### OS X

```bash
brew install lua51
brew install luajit
luarocks-5.1 install magick
luarocks-5.1 install luafilesystem
cd /path/to/repo
```
