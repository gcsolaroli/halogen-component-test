# Halogen component test

Simple project to experiment and try to understand how to use Halogen 5.x components.

## Initial setup e first build

    > nvm install --lts (10.16.3)
    > npm install -g purescript@0.13.3
    > npm install -g spago@0.9.0
    > npm install -g parcel-bundler@1.12.3
    > npm install -g sass@1.22.10
    > npm install -g yarn@1.17.3
    > npm install -g purty@4.5.1
    > yarn build


## VSCode integration

To support editing Purescript files, there are two useful VSCode plugins:
- PureScript IDE: https://github.com/nwolverson/vscode-ide-purescript
- PureScript Language Support: https://github.com/nwolverson/vscode-language-purescript

In order to have errors highlighted directly into VSCode, you need to set one option into the "PureScript IDE" module:
- "purescript.editorMode": true (Editor Mode: Whether to set the editor-mode flag on the IDE server)

To run the application, just type the following two commands in two different terminal windows:
- `yarn develop-purs`
- `yarn develop-app`

The first command will invoke `spago` to continuosly compile the PureScript files, while the second will start a web server to serve the application on a local port, reported by [`ParcelJS`]() logs:

    >> starting...
    Server running at http://localhost:1234 
    ✨  Built in 2.36s.
