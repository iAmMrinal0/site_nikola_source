<!--
.. title: Was trying out Nix all for nix?
.. slug: was-trying-out-nix-all-for-nix
.. date: 2019-08-23 23:57:45 UTC+05:30
.. tags: nix, nixos, haskell, programming, development, arch, linux
.. category: technical
.. link:
.. description: My experience using Nix and NixOS
.. type: text
-->

Yes, I searched for what "nix" means just to see if I could make a funny title out of it. For the lazy, "nix" means "nothing." It's been a long time since I wrote a post and I thought I'd write on my recent learning and experiences using NixOS and Nix (the package manager). You know how when you have your machine stable and working without issues for a while and you have this itch to try something shiny? No? Yes? Only me? Okay. So that's exactly what happened after I'd been using Arch Linux for 4 years. Long story short, I like NixOS so far after my usage of 4 months. <!-- TEASER_END -->

I still remember the day when Paul, who is a mentor at work, with all excitement said, "I've been using NixOS and it is awesome!" And while still being excited he was explaining to me how it works, how the setup is deterministic and how it takes the simple concept of symbolic links to manage your complete system. This pushed me to start trying it out and see for myself if it really is as he claims, "awesome".

### The Good, the Bad, and the Ugly

#### The Good

I've been able to manage a couple of my systems using configuration files and replicate the exact NixOS setup. I've messed with a lot of fonts, wireless tools while I was on Arch that I had no documentation to replicate the setup whenever I moved to a new machine. NixOS with its `configuration.nix` has been a breeze to setup and the configuration file is self documented and I have it version controlled too!

Every configuration change is a new "generation". These generations allow you to rollback to any of the config change, whenever you want to. You are provided generation selection as an option while the system boots.

Installed something and it screwed the system? (yeah, looking at you display drivers) Easy to rollback when you get a blank screen, rather than tinkering and removing the package or downgrading the package through esoteric means.
Once I ruined my config trying out wireless vs Network Manager and I couldn't get it working, and all I had to do now was select a different generation to boot into.

I've been using `nix-shell` for development for my Haskell and Python projects. And I've had to deal with system level packages and on Arch I'd just blindly install that and get away with it, forgetting altogether. Meanwhile, on NixOS, unless I really need the package system-wide I don't install it and just provide it in my `shell.nix` as a build dependent. `nix-shell` gives you a shell with the dependencies you specify, like a virtual environment, if you will.

#### The Bad

I've had to use a few packages not available in `nixpkgs` and had to write derivations for those. The Nix community is not as big as the Arch community hence it is possible that the new, shiny, package that a user released on AUR may not be available.

Getting used to `nix-shell` way of development takes a bit of time to setup. For Python, where `pypi2nix` is under development, it's possible that it might not work for everyone.

#### The Ugly

The learning curve, different file system, documentation, error messages. It was pretty difficult in the initial days to get something done with Nix, because it was new and also that I had to read the actual source code to understand how things were working. NixOS does not follow the Filesystem Hierarchy Standard and thus it could be difficult for people who expect the file structure in a particular way when they come from a different operating system.

The error messages are not as descriptive and understandable even with `--show-trace` and unless you know where you went wrong or know how it all works, best of luck, you are looking at debugging it blindly for a while.

## Should you or should you not?

You might want to try Nix, if you are someone who:

* wants to maintain your system using a configuration file which you could version control.
* wants the exact same setup on two different machines.
* tinkers a lot with their system and wants to have a rollback mechanism when you mess something up.
* prefers to *not* install system dependencies for a project globally.
* prefers separation between system and user packages.

Similarly, you might not want to try Nix, if you are someone who:

* doesn't like to modify configuration frequently.
* likes an out of the box experience.
* use a few unconventional packages, like from the AUR frequently.
* prefers to stay on the latest and greatest of the packages.

Few terminologies:
- `configuration.nix`: System config used by NixOS
- `nix-shell`: Command used to start a new development shell using a `shell.nix` or `default.nix` file
- `pypi2nix`: Tool used to convert Python packages to Nix derivations
- `AUR`: Arch User Repository

Overall, the functional programming Slack group has been helpful. However, it was more of personal exploration, digging deep whenever I hit a roadblock. Now that I've seen and experienced the issues, I plan to work on the documentation and if possible contribute on the packages side.

## Links

My Nix configuration: [nix-config](https://github.com/iammrinal0/nix-config)
