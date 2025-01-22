[![changelog title image](https://files.catbox.moe/fujmqa.png)](https://design.penpot.app/#/view/7b8778b5-b939-80fe-8005-8b3dbcbe8096?page-id=7b8778b5-b939-80fe-8005-8b3dbcbe8097&section=interactions&index=0&share-id=d7727c3e-6ff4-8175-8005-95c838013584)

# Changelog

This is a provisionary changelog for until someone develops a less-hellish [changesets](https://github.com/changesets/changesets) replacement

## v0.1.0

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

## v0.0.0

- Initial Release
