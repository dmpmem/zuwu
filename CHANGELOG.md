[![changelog title image](https://files.catbox.moe/fujmqa.png)](https://design.penpot.app/#/view/7b8778b5-b939-80fe-8005-8b3dbcbe8096?page-id=7b8778b5-b939-80fe-8005-8b3dbcbe8097&section=interactions&index=0&share-id=d7727c3e-6ff4-8175-8005-95c838013584)

# Changelog

This is a provisionary changelog for until someone develops a less-hellish [changesets](https://github.com/changesets/changesets) replacement

## v0.3.0 [`current-commit`](https://git.estrogen.zone/zuwu.git/commit/?h=v0.3.0)

### Features

- **Breaking:** Add a `USE_COLOURED_LS_GREP` environment variable (defaulting to `true`), that adds `--color=auto` to `ls` and `grep` unless `color=` is in the relevant `which`'s return value ([`71385bc`](https://git.estrogen.zone/zuwu.git/commit/?id=71385bcaa56690e1320a4b8b3f8af70a7d6938f2))
  - To disable, do one of:
    - Before zuwu is loaded, set the aliases `alias ls="ls --color=never"` and `alias grep="grep --color=never"`
    - Pass it to the specific invocation - most implementations will use the last `color=`
      - This won't work if the implementation dies when it's specified at all
    - Set `USE_COLOURED_LS_GREP=false` in your `${XDG_CONFIG_HOME:-"$HOME/.config"}/zuwu.conf`
- **Breaking:** Add ctrl+del binding to `delete-word` ([`c5faf5f`](https://git.estrogen.zone/zuwu.git/commit/?id=c5faf5f1db6a3eb88e7c1c38c05d2cd1df8a3d57))
  - To disable, add `DELETE_CHAR=false` to your `${XDG_CONFIG_HOME:-"$HOME/.config"}/zuwu.conf` config file.
  - Once disabled, to return the old `del` character behaviour (which is still present), add `bindkey "^[[3~" delete-char && bindkey "^[[3;2~" delete-word` to your `.zshrc` **after** the zsh load.

### Fixes

- Resolve a code of conduct moment ([`927e7e6`](https://git.estrogen.zone/zuwu.git/commit/?id=927e7e66d065d38bb8a891171945e6ecdb6a6abe))
- Resolve a config handling bug ([`e90726c`](https://git.estrogen.zone/zuwu.git/commit/?id=e90726c70dd224f1473124ffb05f1720056ea740))
- Resolve another config handling bug ([`81defa2`](https://git.estrogen.zone/zuwu.git/commit/?id=81defa2bbcf3d1a76eb6b7befcd7761690dc2af5))

## v0.2.1 [`fddadc4`](https://git.estrogen.zone/zuwu.git/commit/?id=fddadc4c0e678903a340058e561d37f3773e36d6)

### Misc

- Add comment describing loading priority of paths ([`04155f5`](https://git.estrogen.zone/zuwu.git/commit/?id=04155f5d1afb2313c57daf98109e20bb6f3e22c9))
- Make setup.zsh `set -e`'d ([`2177c3a`](https://git.estrogen.zone/zuwu.git/commit/?id=2177c3a6fc6ae8a167e6c1b164ab0022595c38d9))
- Add a `pending release` changelog section ([`9d97d45`](https://git.estrogen.zone/zuwu.git/commit/?id=9d97d456cffd0db4ea7074cdda803cb10debe18a), [`e4bebb3`](https://git.estrogen.zone/zuwu.git/commit/?id=e4bebb3a813411558f6993c4da64c0d667827a18))

### Fixes

- Use `XDG_{CONFIG,DATA}_HOME` instead of `$HOME/{.config,.local/share}` ([`1c202b4`](https://git.estrogen.zone/zuwu.git/commit/?id=1c202b4bb8bc8e1e9a951c3b85101c5c59821896))

## v0.2.0 [`a985eb2`](https://git.estrogen.zone/zuwu.git/commit/?id=a985eb25f2a44dc3d40d29210306e118f19f1784)

### Features

- Default to sharing history between shells ([`f598c8a`](https://git.estrogen.zone/zuwu.git/commit/?id=f598c8aac0a93ff477974d3bbde14aef34c0ae85))
- Ensure LANG and LC_ALL are set - and outside of a login shell, have UTF-8 available ([`d08ee7b`](https://git.estrogen.zone/zuwu.git/commit/?id=d08ee7b1f0ae2bbd3491939557032c6117807dae), [`9300c0e`](https://git.estrogen.zone/zuwu.git/commit/?id=9300c0e8c19352da49c99b07b3d8086d1403e331))
- Ensure `$HOME/.local/bin` is in PATH ([`cc3c1f5`](https://git.estrogen.zone/zuwu.git/commit/?id=cc3c1f5e9f132716bad18fd8f956bb4ae0517bcb))

### Misc

- Properly define copyright and license information ([`8360523`](https://git.estrogen.zone/zuwu.git/commit/?id=8360523f9fedd19b70abfd5fa6ed239655ea49e0))
- Create small utility script for referencing commits ([`43cb34c`](https://git.estrogen.zone/zuwu.git/commit/?id=43cb34cbb14d45f19a7cac040e2f22fd58f9f14e))
- Use codeblocks for commit ids ([`dc50fbb`](https://git.estrogen.zone/zuwu.git/commit/?id=dc50fbb52806b9b123049a440d0bedeac9667bba))

### Fixes

- Only call `__sethist` after definition on first run ([`f104b3c`](https://git.estrogen.zone/zuwu.git/commit/?id=f104b3c3064571df3f90351633390ff37e90b443))
- Avoid grepping contents of `.zshrc` for appending sections ([`9e36977`](https://git.estrogen.zone/zuwu.git/commit/?id=9e36977b9d4641c9fc67eee9b36bdfa8a3b85bbd))
- Only call `__sethist` if it exists - ie if no installation occurs, don't error ([`9e36977`](https://git.estrogen.zone/zuwu.git/commit/?id=9e36977b9d4641c9fc67eee9b36bdfa8a3b85bbd))
- Check against `zgen.zsh` as a file, not `.zgen` as a directory ([`af4b31e`](https://git.estrogen.zone/zuwu.git/commit/?id=af4b31e2e0f6d1aff38781b3cc4367af52b39460))
- Don't export `LOADED_ZGEN` to processes ([`93757c9`](https://git.estrogen.zone/zuwu.git/commit/?id=93757c93590fa21ff040a51e72f7698cfb5f444a))

## v0.1.0 [`7b7453c`](https://git.estrogen.zone/zuwu.git/commit/?id=7b7453cae1d9f75d5665ed0dba4870774861b9ee)

### Features

- Add per-host `$PROMPT` colour generation ([`7307bfb`](https://git.estrogen.zone/zuwu.git/commit/?id=7307bfb7b13ee5556a3d5e10346169cbbfae66cb), [`ffe8836`](https://git.estrogen.zone/zuwu.git/commit/?id=ffe88360c306a300ef2849f11f88b20b93a6d949), [`3602b63`](https://git.estrogen.zone/zuwu.git/commit/?id=3602b633857ce4bf01f1158e4f2985083bbb6917))
  - Provide environment variables for decreasing (already insanely low) zuwu loading times at a cost of features ([`867b49f`](https://git.estrogen.zone/zuwu.git/commit/?id=867b49fc00d54fac0a0dd875bfbdd161083d860f))
  - Use Shell Builtins for calculating hostname colour ([867b49f..`5a83d10`](https://git.estrogen.zone/zuwu.git/diff/?id=5a83d107a98d0d0f3b15dc73103c915ec6deaf1f&id2=867b49fc00d54fac0a0dd875bfbdd161083d860f))
- Create a (more or less) blank `.zshenv` for the user ([`5ed7a6e`](https://git.estrogen.zone/zuwu.git/commit/?id=5ed7a6e03b0d76177d95e01920f57688e648bd5f))
- Install the `COPYING` file into the installed environment ([`17ef8dd`](https://git.estrogen.zone/zuwu.git/commit/?id=17ef8dd1653b0d6b83a2ff18bcb4c5a7a0c9581c))
- Allow specifying the ref to install from for `install.zsh` ([`50387c6`](https://git.estrogen.zone/zuwu.git/commit/?id=50387c6d103a7e9031000843c81d6e378ff7cbc4))

### Misc

- Create a README ([`5ec88e7`](https://git.estrogen.zone/zuwu.git/commit/?id=5ec88e78e9f02d68b02156f3943444da859d7887), [`4500596`](https://git.estrogen.zone/zuwu.git/commit/?id=4500596485db2cfe6d1f65626644e9692945a6ba), [`fdb29a0`](https://git.estrogen.zone/zuwu.git/commit/?id=fdb29a0b2096745cddb7f64a634b88558849e473), a few others)
- License under MIT ([`702e934`](https://git.estrogen.zone/zuwu.git/commit/?id=702e934bec9ba2105f278cdab97ae272cdac03b3))
  - Rant about LLMs ([`0652590`](https://git.estrogen.zone/zuwu.git/commit/?id=0652590d95070eba229544ad63c0cf8d686b2ffa), [`c4de2e9`](https://git.estrogen.zone/zuwu.git/commit/?id=c4de2e9c0594db30594ff9c071eee73939e7b9ec))

## v0.0.0 [`d2d86dd`](https://git.estrogen.zone/zuwu.git/commit/?id=d2d86dd3162c0cfd2541bb82026f6e6cdd8573b0)

- Initial Release
