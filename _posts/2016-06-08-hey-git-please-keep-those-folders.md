---
image: https://dimg.kinduff.com/Hey git, please .keep those folders.jpeg
title: Hey git, please .keep those folders
date: 2016-06-08
description: How to commit "empty" folders to a git repository.
lang: en_US
---

**tl;dr** create a .keep file to check-in folders in git and add the following
lines to your .gitignore to ignore the files within:

```bash
# ignore files in folder foo
foo/*

# but keep the folder
!foo/.keep
```

This method is useful for the following cases:

1.  You want to push a directory structure to git **before having files**.
1.  You want to check-in a directory but not the files.
1.  You just want to push an empty folder — lol.

Remember that this is not a git feature or anything like that, this is done
using an undocumented file name convention (_keep_ or _gitkeep_) and the prefix
to [negate a pattern](https://www.kernel.org/pub/software/scm/git/docs/gitignore.html#_pattern_format).

Just create an empty folder and create a _0kb_ file called _.keep_

```bash
$ mkdir logs
$ touch logs/.keep
```

You can call it _.keep_ or _.gitkeep_, they are useful for the exact same thing
and the name of it its just a convention (Rails and some Node generators). This
file is going to allow git to include the directory. You can delete it after you add the first file.

If you want to ignore everything inside the _foo_ directory but you also want to check-in this folder, add the following lines in your _.gitignore_

```bash
# ignore all logs files
logs/*

# don't ignore keep files
!.keep
```

If you create a new file inside _logs_ directory it is going to be ignored but
the directory (because of the _.keep_ file) is going to be checked-in.

## Further explanation

Consider the following scenario. We create a git repository.

```bash
$ mkdir test && cd $_
$ git init
Initialized empty Git repository in /route/test/.git/
```

Then we create a logs folder that we want to check-in.

```bash
$ mkdir logs
$ git status
nothing to commit
```

In order to save those files we need to create a file called _.keep_ with _no content_.

```bash
$ touch logs/.keep
new file:   logs/.keep
$ git commit -am 'Adds log directory'
```

Now, if you also want be able to check-in the folder, but not its content —
makes sense for a logs file, add the following content in your _.gitignore_
file.

```bash
# ignore files in folder logs
logs/*

# but please keep the folder
!logs/.keep
```

> **Disclaimer:** Git will know if you didn’t put the word _please_ in the
> comment. This won’t work if you miss it.

Commit that and now if we create new files in the folder or do any change to
existing files, these are not going to be checked-in by git.

```bash
$ touch logs/development.log
$ git status
  nothing to commit, working directory clean

$ touch logs/production.log
$ git status
  nothing to commit, working directory clean
```

That’s it. Thanks for reading.
