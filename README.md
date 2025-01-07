![readme title image](https://web.archive.org/web/20250107095158if_/https://files.catbox.moe/sg16ei.png)

# zuwu.zsh &mdash; usable defaults for zsh

zuwu.zsh (zuwu) is a highly opinionated zsh "plugin" that provides sensible defaults for keybindings and completions, aswell as attempting to load a few plugins, as to make `sudo apk add zsh zsh-fast-syntax-highlighting zsh-autosuggestions` (note: these are optional, they're just recommended) followed by installing zuwu be sufficient for an enjoyable shell experience.

## installation

### from repo

Run `git clone https://git.estrogen.zone/zuwu.git /tmp/zuwu --depth 1 && cd /tmp/zuwu && ./install.zsh && cd - && rm -rf /tmp/zuwu`

then follow the outputted instructions.

> Replace `./install.zsh` with `doas ./install.zsh` or `sudo ./install.zsh` to get a system-wide install

### from package

#### alpine

The [alpine-packages.git](https://git.estrogen.zone/alpine-packages.git/) repository on [git.estrogen.zone](https://git.estrogen.zone) contains [a package for zuwu](https://git.estrogen.zone/alpine-packages.git/tree/src/memdmp/zsh-zuwu). In the near future, this package will be provided on a 3rd-party repository of some kind.

For now, you can build the package yourself; in the cloned repository, assuming [alpine-sdk is installed](https://pkgs.alpinelinux.org/package/edge/main/x86_64/alpine-sdk) and [abuild keys have been setup](https://wiki.alpinelinux.org/wiki/Abuild_and_Helpers#Setting_up_the_build_environment), you can run `FILTER=zsh-zuwu ./build-repo` to build the package, and `doas ./pkg add zsh-zuwu` to install it. The package will, on installation, provide the path needed for the script that configures your `.zshrc`.

#### when living life dangerously

```sh
curl -fsSL https://git.estrogen.zone/zuwu.git/plain/install.zsh | zsh
```

(add `doas` or `sudo` before the `zsh` command for a system-wide install)
