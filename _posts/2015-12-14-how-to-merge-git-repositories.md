---
title: How to merge git repositories
date: 2015-12-14
description: Process on how to merge two different git repositories, either just a folder from B to A or the complete repository B into A.
lang: en_US
---

> We were working on a project that had its own git repository and commit history.
>
> One month later the requirements pointed towards moving the project into an existing one with its own commit history. And one month later we had to move a specific folder from the repository into a new one.
>
> Believe it or not the repositories were merged preserving their commit history in both cases.

**tl;dr** Clear process of how to merge **Repository B** into **Repository A** git repositories, merging everything as it is, into a new directory or only one directory, preserving the commit history.

## Merge Repository B into Repository A

Following these steps you will merge **Repository B** into **Repository A** preserving the same directories and file structure and history from both repositories.

**Step 1:** Access the **Repository A** directory to start the merge.

```bash
$ cd repository_a
```

**Step 2:** Add the **Repository B** as a remote within the **Repository A**.

```bash
$ git remote add repository_b ~/path/to/repository_b
```

**Step 3:** Pull the remote into the master branch or whatever branch you want.

```bash
$ git pull repository_b master
```

**Step 4:** Remove the remote we just added so we don’t mess up in The Future™.

```bash
$ git remote rm repository_b
```

**Profit:** By now, **Repository A** should have directories and files from **Repository B** as well as the commit history. You can run _git log_ to make sure.

## Merge it into a new directory

With this method you will merge **Repository B** into **Repository A** within a new directory or an existing directory preserving the git history from both repositories.

**Step 1:** Access the **Repository B** directory to start the merge setup.

```bash
$ cd repository_b
```

**Step 2:** Create the a custom directory structure inside the Repository B.

```bash
$ mkdir repo_b
```

For example, if you want all the content from **Repository B** to be inside the **src/repo_b** directory within the **Repository A**, you will need to create the following directory.

```bash
$ mkdir src/repo_b
```

**Step 3:** Move the files you want or all of them inside the new directory.

```bash
$ git mv * src/repo_b/.
```

**Step 4:** Commit the change.

```bash
$ git add .
$ git commit -m 'Prepare repository_b to merge into repository_a.'
```

**Continue:** Follow the instructions above from the sections **Merge it into a new directory** or **Merge Repository B into Repository A**.

## Merge only one directory

With this method you will merge a specific directory from **Repository B** into **Repository A** preserving the git history from both repositories.

**Step 1:** Access the **Repository B** directory to start the merge setup.

```bash
$ cd repository_b
```

**Step 2:** Filter out using filter-branch git command to exclude everything else and rewrite the history from the directory. Note that this command will rewrite all the git history from the **Repository B** so working in copy of the project is recommended.

```bash
$ git filter-branch --subdirectory-filter <my_folder> <branch>
```

**Continue:** Follow the instructions above from the sections **Merge it into a new directory** or **Merge Repository B into Repository A**.
