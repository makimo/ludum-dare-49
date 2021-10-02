# Audio Spectrum

This is a demo showing how a spectrum analyzer can be built using Godot.

Language: GDScript

Renderer: GLES 2

Check out this demo on the asset library: https://godotengine.org/asset-library/asset/528

## Screenshots

![Screenshot](screenshots/spectrum.png)

## Running and exporting

There are two scripts:

```
./server.sh
```

This one starts a HTML server (via browsersync) that shows the `game`
directory, where game can be exported.

```
./export.sh
```

This one rebuilds the game, provided that you have `godot` in your PATH.
It exports the HTML5 preset into the `game` directory, which triggers browser
reload.
