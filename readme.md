# Setup

You will need Keen installed: https://keen.foo

Optional: `sudo apt install libudev-dev libevdev-dev`. This prevents a warning from logging but isn't actually necessary.

Then just run: `make run`


# Testing

The game has several test states listed in `main.keen`. To use one, run a command like: `make run ARGS=playground`

You can enter debug commands into the console. For example: `set player.pos 10, 20`. See `debug-commands.keen`.

To test in JS, run `make serve`. To initialize the JS to a particular state, use a URL like http://localhost:8080/?state=kitchen .

In JS, you can enter commands like `debug("set player.pos 10, 20")` in the browser console.


# Development notes

Be sure to run `make bin/puzzles` after any change that affects what puzzles exist (or after a change to the puzzle generation). This takes 5 minutes.

Level maps use [Tiled](https://www.mapeditor.org/). Tiled tile maps (`.tsj` files) have upside-down coordinates relative to the game.
So what displays as `3, 7` in Tiled will be `3, -7` in the game.

Every level should have exactly 2 layers, a "tiles" layer and an "objects" layer. The "tiles" layer should use the tileset for that level, and the "objects" layer should only use `objects.png`. The tiles layer gives the level layout, and the objects layer is for things that go on top of the tiles. It's important to add things to the right layer, or the game will throw an error when you enter the area.

For a list of objects, see `tile-object-kind` in `game-types.keen`.


# Testing changes to submodules

Suppose you want to test a change to your local version of `game-backend`.
To start development, run:

```sh
[ -L lib/game-backend ] && echo "Already a symlink" || rm -r lib/game-backend && ln -s ../../game-backend lib/game-backend
```

That this leads to a dirty git state.

When you are done, run:
```sh
rm lib/game-backend
git submodule sync lib/game-backend
git submodule update --init --recursive --force
```
