# Code of Conduct

## Sensibility/Behaviour Guidelines

1. Don't be an asshole.
2. Don't be transphobic/homophobic/etc... unless you are in a minority affected by the same problem - no, [counter to popular belief](https://catgirl.center/notes/a2dnlu8p43n905jt), cishet white males are not minorities*. This will (usually) not be enforced if the behaviour is found outside of the scope of the project, however pls dont exhibit it there either ty :3
3. Enforcement of these rules is entirely subjective - my project, my guidelines, my enforcement. If you don't like it, [read the LICENSE](./COPYING), and fork the fuck.

<small>* yes there are exceptions, however being a cishet white male is not a factor that puts you into a minority</small>

## Contribution Guidelines

### Upstream

The upstream repository is *not* [github.com/dmpmem/zuwu.git](https://github.com/dmpmem/zuwu.git) - it is [git.estrogen.zone/zuwu.git](https://git.estrogen.zone/zuwu.git/). Github is a "best-effort-basis" mirroring platform, mostly used to bootstrap [git.estrogen.zone/cgit-oci.git](https://git.estrogen.zone/cgit-oci.git/tree/Containerfile?id=df5e75dcd0b30b1e40b49ac01ce6265a592bdfc7#n81)'s shell when built on [git.estrogen.zone](https://git.estrogen.zone).

Please clone from `https://git.estrogen.zone/zuwu.git`;

```sh
git clone https://git.estrogen.zone/zuwu.git
```

### Where to submit patches

Send them [as patches](https://git-scm.com/docs/git-send-email) to the email address of [this commit](https://git.estrogen.zone/zuwu.git/commit/?id=4500596485db2cfe6d1f65626644e9692945a6ba), **not** as a Github PR. Please read the rest of this document before doing so, though.

### AI

#### Use in Training Data

As long as your model complies with the [MIT License](./COPYING) and outputs it verbatim with any substantial (as determined by a swiss court) copy of any portion of the code in this repository, enjoy. If it does not output the entire license **consistently, correctly, *including* copyright lines**, you may not use this project in your training data.

If you have discovered this project being inappropriately used by a machine learning model as part of starting a class-action lawsuit, please contact me at the email address of the above commit. I will happily participate.

#### Use in Contributions

Don't make your contributions Generative Machine-Learning based.

AI-generated code is usually subpar garbage that is unmergable without a complete rewrite, and has [the same ethical constraints as all other AI-based tooling](https://web.archive.org/web/20250108164402/https://www.tomshardware.com/software/linux/linux-distros-ban-tainted-ai-generated-code).

AI-generated commit messages have the same flaw(s).

#### Why do I have this AI section?

A bit ago (01/03/2025, at 06:46 GMT+1), I got the below email - attached in it's entirety, without headers:

```txt
Below is an enhanced and refactored version of your Zsh plugin installation script. It retains the same functionality—installing the zuwu.zsh script to a user’s or system prefix and providing a setup script—while improving readability, maintainability, and error handling. The script also includes explanatory comments so you can further customize the install process if needed.

Note: This script remains a zsh-oriented shell script. Make sure you run it under zsh (or the script can be invoked via #!/usr/bin/env zsh). If you run it under another shell, some behaviors might differ.

Explanation of Improvements
Strict Bash/Zsh Modes
We added set -euo pipefail at the top to ensure the script exits on errors, treats unset variables as errors, and fails on pipe errors. This is generally good for robust scripting.

Utility Functions

info, warn, error: Provide consistent, color-coded logging functions. This centralizes printing logic, making the script more readable and maintainable. Color Constants

Define constants like COLOR_GREEN, COLOR_BLUE, etc. for consistent usage and easier modifications later. This avoids scattering color escape sequences throughout the code. Variable Renaming

INSTALL_DIR is easier to read than TARGET while also clarifying that it’s a directory. The original logic is preserved: If $TARGET is set externally, we use it; otherwise, we guess a suitable path. Checks &amp; Clarity

Scripts now handle missing environment variables more gracefully with &quot;${VARIABLE:-}&quot;. We explicitly document or group script sections with comments. Install Function

We turned your inline logic into a single function installFile() that can be reused or extended. Clear separation of copying/curling from the original code. Setup Script

The setup.sh content is placed into a here-document (cat &lt;&lt;&#39;EOF_SETUPSCRIPT&#39; ... EOF_SETUPSCRIPT), clarifying that it’s a separate script living in $INSTALL_DIR/setup.zsh. We mark it executable with chmod +x.
User Guidance

We print final instructions using the info() function, so the user knows exactly what to do next. You can easily adapt this script to handle more advanced logic—like verifying your environment is Zsh, adding additional validations, or merging user .zshrc content rather than overwriting it.

Enjoy your improved Zsh plugin installer!
You can view, comment on, or merge this pull request online at:

  https://github.com/dmpmem/zuwu/pull/1

-- Commit Summary --

  * Update install.zsh

-- File Changes --

    M install.zsh (137)

-- Patch Links --

https://github.com/dmpmem/zuwu/pull/1.patch
https://github.com/dmpmem/zuwu/pull/1.diff

-- 
Reply to this email directly or view it on GitHub:
https://github.com/dmpmem/zuwu/pull/1
You are receiving this because you are subscribed to this thread.

Message ID: &lt;dmpmem/zuwu/pull/1@github.com&gt;
```

This PR, made by an unknown (due to github marking them as spam :3) account, is obviously AI generated in it's entirety, does not address anything serious, includes a reference to the existing code without describing a change, does idiotic things like "INSTALL_DIR" being prioritized over a perfectly fine "TARGET". This both used my code as an input to an LLM (and likely added it to the training data being used by whatever company runs said LLM), and gave garbage out.

The only usable change was the `set -euo pipefail` being used over `set -e`. This is theoretically [bad practice](https://bbs.archlinux.org/viewtopic.php?id=240984), however is a theoretically ok addition as I had forgotten to run shellcheck (which outputted nothing useful) and shellharden on the scripts in this repo to this point.
