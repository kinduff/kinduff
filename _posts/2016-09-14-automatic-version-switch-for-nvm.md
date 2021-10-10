---
title: Automatic version switch for NVM
date: 2016-09-14
description: Switching NVM version automatically whenever you go into a project folder.
lang: en_US
---

If you’re using multiple versions for each of your projects, you might use the `nvm use` command every time you need to switch. This gets old very fast and `nvm` doesn’t have a native solution for this problem.

The [NVM documentation](https://github.com/creationix/nvm) has a dedicated section for this. You can go and read them there or continue reading for a curated version.

### Manual Switch

The manual switch involves a file called `.nvmrc` in your project’s directory.

```bash
echo "5.9" > .nvmrc
echo "lts/*" > .nvmrc # to default to the latest LTS version
```

In order to switch, you’ll need to run `nvm use` but if you cd outside of the directory, the version is not going to switch back to your default.

**Pros**

- No additional setup or environment mods.
- You can commit the file to be shared with peers.
- Control over the version switch: how and when.

**Cons**

- No automatic switch when cd’ing into the project.
- No default restore when cd’ing outside the project.

### Automatic Switch

The automatic switch will switch your node version automatically when you cd into a project folder that contains the `.nvmrc` file. You’ll need to have `zsh` as a shell to make this work.

Add the following content at the end of your `.zshrc` file, after the `nvm` initialization.

```bash
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
```

Now every time you cd into a directory you’ll switch to the project version if it has the `.nvmrc` inside with a valid version.

If you go out of the directory or cd into a directory that doesn’t have the version file, your shell will use the default one in your system.

**Pros**

- Automatic switch inside and outside project specific versions.
- Automatic default version switch if no version is specified.

**Cons**

- ZSH dependency.
- Additional script block in local machine.

That’s it for now, please add in the comments if you’re familiar with another solution.
