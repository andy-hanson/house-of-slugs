# House of Slugs

If you just want to play the game, go here: https://andy-hanson.github.io/house-of-slugs


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

Be sure to run `make update-puzzles` after any change that affects what puzzles exist (or after a change to the puzzle generation). This takes 15 minutes.


# Testing changes to submodules

Suppose you want to test a change to your local version of `game-backend`.
To start development, run:

```sh
[ -L lib/game-backend ] && echo "Already a symlink" || rm -r lib/game-backend && ln -s ../../game-backend lib/game-backend
```

or:

```sh
[ -L lib/grid ] && echo "Already a symlink" || rm -r lib/grid && ln -s ../../grid lib/grid
```

That this leads to a dirty git state, so don't commit anything before cleaning up.

When you are done, run:
```sh
rm lib/game-backend
git submodule sync lib/game-backend
git submodule update --init --recursive --force
```
