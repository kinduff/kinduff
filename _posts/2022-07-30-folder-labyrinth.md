---
title: Folder Labyrinth
date: 2022-07-30
description: >-
  I used to create folder labyrinths when I was a teen.
---

When I was in my teenage years the only computer I had access to was a desktop computer shared by my whole family. That's where I learned how to use the internet, how to code, edit photos, and create animations.

At this age, I had a lot of curiosity, and let's say I wanted to hide "dog pictures" from my other family members. We all had a password-protected account, but the folders were not encrypted and they were accessible from other accounts.

In order to hide my dog's pictures, I used to make folder labyrinths. I would write down my secret code in a hidden notebook I used to have. For example, the code for my dog pictures was `bba`.

Here is a tree structure as an example:

```
.
├── a
│   ├── a
│   │   ├── a
│   │   ├── b
│   │   └── c
│   ├── b
│   │   ├── a
│   │   ├── b
│   │   └── c
│   └── c
│       ├── a
│       ├── b
│       └── c
├── b
│   ├── a
│   │   ├── a
│   │   ├── b
│   │   └── c
│   ├── b
│   │   ├── a <- dog pictures
│   │   ├── b
│   │   └── c
│   └── c
│       ├── a
│       ├── b
│       └── c
└── c
    ├── a
    │   ├── a
    │   ├── b
    │   └── c
    ├── b
    │   ├── a
    │   ├── b
    │   └── c
    └── c
        ├── a
        ├── b
        └── c
```

It worked apparently because no one ever found my dog pictures (yes, I asked years later).

Of course, the top-level folder was a hidden folder, a very nice trick in Windows XP. Other tricks were to use a transparent image and an invisible Unicode character to hide it in plain sight.

It may be weird to talk about this because of course, you know that I was not hiding dog pictures. But it's curious how I use this, among other tricks, to have a personal space in a shared computer.

I would do the labyrinths by hand, it took me hours, even though I had some experience coding with Batch, but I was only 13-14 years old.

Today if I wanted to do something similar, I would encrypt it, plain and simple, but here's a script I made in Bash to automate the process. The output of this basic script yields a path where the dog pictures should be.

```shell
#!/bin/bash

CLEAR='\033[0m'
RED='\033[0;31m'

function usage() {
  if [ -n "$1" ]; then echo -e "${RED}$1${CLEAR}\n"; fi

  echo "Usage: $0 <--depth depth> <--target dir> [--help]"
  echo "  -d, --depth             The depth of the labyrinth to generate"
  echo "  -t, --target            Directory to run the generator"
  echo "  -h, --help              Prints this help"
  echo ""
  echo "Example: $0 --depth 3 --target ."
  exit 1
}

# parse params
while [[ "$#" > 0 ]]; do case $1 in
  -d|--depth) DEPTH="$2"; shift;shift;;
  -t|--target) TARGET="$2";shift;shift;;
  -h|--help) usage;;
  *) usage "Unknown parameter passed: $1"; shift; shift;;
esac; done

# verify params
if [ -z "$DEPTH" ]; then usage "Depth is not set"; fi;
if [ -z "$TARGET" ]; then usage "Target id is not set."; fi;

function generate_tree() {
  local depth=$1
  local current_depth=$2
  local target=$3

  if [ "$current_depth" == "$depth" ]; then
    return
  fi

  for i in $(seq $depth); do
    local name=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c2)
    local dir="$target/$name"
    mkdir -p $dir
    generate_tree $depth $((current_depth + 1)) $dir
  done
}

generate_tree $DEPTH 0 $TARGET

find $TARGET -mindepth $DEPTH -type d | sort --random-sort | head -1
```
