## About Krew

[krew](https://github.com/kubernetes-sigs/krew) is a tool that makes it easy to use kubectl plugins. krew helps you discover plugins, install and manage them on your machine. It is similar to tools like apt, dnf or brew. Today, over 55 kubectl plugins are available on krew.

For kubectl users: krew helps you find, install and manage kubectl plugins in a consistent way.
For plugin developers: krew helps you package and distribute your plugins on multiple platforms and makes them discoverable.

## About Fast Krew

Fast Krew is just a krew bash wapper that uses [axel](https://github.com/axel-download-accelerator/axel) to download plugin package.

## Installation

1. Make sure that both `axel` and `krew` are installed.
2. Run `kubectl krew  update` before install your plugin.
3. Run this command in your terminal to download plugin using fast krew:

```bash
./fast_krew.sh <plugin_name>
```

![fast krew demo](./fast_krew.gif)
