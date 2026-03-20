
<div align="center" style="display: flex; flex-direction: column;">
<img src=".github/images/main_gif.gif" width="200">
</div>

<h1 align="center">
  <div >
<span > Personal configuration files </span>
  </div>
  <br>
</h1>

## WIP
j

I also want to have super o

## WIP

<!-- Cool ideas, but no use yet or no much benefit yet -->
<!-- * create collection of git hooks for quality of life that will be copied in every repo cloned -->
<!-- * browser specific shortcuts that will set shift+X to ctlr tab, etc. also S->> and S-<< -->
<!-- - add fzf plugin to command history in nvim | Telescope has this functionality? -->
<!-- Make single leader key in all programs and nvim  -->
<!-- - make it so sessionizer would take git ssh https or just plain text to create a folder -->
<!-- - remove default gnome keybind to lock the screen  -->

<!-- for pok openining in new tabs from terminal -->
<!-- https://github.com/mhinz/neovim-remote -->
<!-- https://lemmy.world/post/1563173 -->

### TODO: nvim :

P0
- Learn how to use nvim harpoon
- Learn how to use nvim fugitive
- syntax highlighting for helm go templates
- make alt+1 work for tabs
use normal lsp and formatter for html

<!-- set upstreadm automatically -->
 ╰$ git branch --set-upstream-to=origin/master master
branch 'master' set up to track 'origin/master'.

I need to make git clonew refresh nvim cache

P1
- I would like to have java neovim setup
- I would like to have containarized neovim setup


### TODO: to learn:

- learn glab and don't interact with gitlab if not needed. Can i use glab to navigate directly to pipelines from cli?

- limit your search to the certain site, e.g. adding site:stackoverflow.com to your search phrase will limit the search to this site, or site:reddit.com inurl:/r/php to even a single subreddit!


## k8s
we need to create root users on debian installation and then change root user passwd in interactive.sh

we need to throw this config to each node ()

192.168.0.107 plane-1
192.168.0.111 node-1
192.168.0.113 node-2

 ╰$ scp hosts plane-1:~/                    
bchk@plane-1:~$ cat hosts >> /etc/hosts

for easier to set up it should be node-0, node-1, server

Disable Swap
Kubernetes has limited support for the use of swap memory, as it is difficult to provide guarantees and account for pod memory utilization when swap is involved.
root@node-1:~# swapoff -a

should be run as **root**



WHYYYYY CARL!
 ╰$ git pull  
There is no tracking information for the current branch.
Please specify which branch you want to rebase against.
See git-pull(1) for details.

    git pull <remote> <branch>

If you wish to set tracking information for this branch you can do so with:

    git branch --set-upstream-to=origin/<branch> master

