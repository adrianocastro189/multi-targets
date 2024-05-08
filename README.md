# MultiTargets

**MultiTargets** allows players to create and maintain **target lists**,
which are lists of names that can be used to quickly target using
a key binding.

![Units with raid markers in Elwynn Forest](https://i.imgur.com/JaTimRB.png "Units with raid markers in Elwynn Forest")

This addon works similarly to a macro that targets a specific
unit by name, using the `/tar` command, but with target lists, **it
will rotate through its names**, so more than one target can be
marked in sequence, with no need to players manually target each one
or update the macro themselves.

## ❤️ Support this project

If you like this addon and want to support its development, you can
[buy the author a coffee](https://github.com/sponsors/adrianocastro189).

Every contribution or subscription is deeply appreciated and also supports
the [Stormwind Library project](https://github.com/adrianocastro189/stormwind-library),
which is the framework used to build this addon.

## How this addon can be used

* **Farming:** Players can create a target list with the names of
   the mobs they want to farm in a specific area.
* **Hunting rares:** Players can create a target list with the names
   of the rares they want to hunt in a specific zone instead of
   manually upating the macro with the names of the current rare
   being hunted.
* **Questing:** When players need to kill specific mobs for a quest,
   they can create a target list with the names of these mobs, so
   it's easier to target them, especially when the quest requires
   killing more than one type of enemy.
* **Raiding and in dungeons:** Players can create a target list
   with the names of the mobs they need to focus on, like the ones
   that need to be interrupted or killed first, then a single key
   binding can be used to target them in sequence.

## How to use this addon

![A Defias being targetted](https://i.imgur.com/tgeFd5t.png "A Defias being targetted")

* Install and enable the addon
* Once you log in, the addon will load the default target list and it's
ready to be used and populated with names
* There are a couple of ways to add names to the target list:
   * **Using the target frame button:** Click on the target frame
      button to add the name of the current target to the target list
   * **Using the chat command:** Type `/multitargets add` followed by the
      name of the target to add it to the target list
   * **Adding the current target with a command:** When the target
      is selected, type `/multitargets addt` to add the name of the
      current target to the target list
* There will be a macro called **MultiTargetsMacro** with arrows and an aim
  icon when you open the Macro dialog (`/m`). Just drag this macro to your 
  action bar and associate a key binding to it if you want.
* Now it's a matter of spamming the macro key binding and the addon will 
  rotate the next targets in the list, marking it with a raid marker

## Available commands

All command line options are available using the `/multitargets` command.

In the addon's first versions, most of its functionalities are available
through the chat command. The addon will have a graphical interface in
the future, but for now, the chat command is the best way to interact
with it.

![A print command example](https://i.imgur.com/WWRhFj0.png "A print command example")

These are the available commands:

* `/multitargets add {name}`: Adds the given name to the target list, 
replacing `{name}` with any name and wrapping it with quotes if it has 
spaces
* `/multitargets addt`: Adds the name of the player's current target to
the target list
* `/multitargets clear`: Clears the target list
* `/multitargets help`: Shows the available commands
* `/multitargets hide`: Hides the target list window
* `/multitargets print`: Prints the names in the target list
* `/multitargets remove {name}`: Removes the given name from the target
list, replacing `{name}` with any name and wrapping it with
quotes if it has spaces
* `/multitargets removet`: Removes the name of the player's current target
from the target list
* `/multitargets show`: Shows the target list window

## What's on the roadmap for the next versions

* **Toolbox in the targets window:** A toolbox above the target list
with buttons to add, remove, clear, and other actions
* **Multiple target lists:** The ability to create and manage multiple
target lists, so players can have different lists for different
situations
* **Better in-combat support:** The addon will disable the target rotation
system when the player is in combat, when macrons can't be updated
* **Better target button:** The target frame button will have a better
visual representation
* **Settings:** Will allow customizing the addon's behavior, also with
a graphical interface
* **Select available markers:** The addon will allow players to select
which markers are available for the target list and their order
* **Automatic macro moved to the action bar:** The addon may try to move
the macro to the action bar automatically if it's not there and the player
has empty slots in the first initialization
* **Localization:** The addon will be localized to support multiple
languages

## Limitations

The addon has some limitations that players should be aware of, mostly
due to the limitations of the World of Warcraft API and the way the addon
was designed:

* **No in-combat support:** The addon will not work in combat, as macros
can't be updated while the player is in combat
* **PvP:** The addon will not mark enemy players, as it's not possible to
use raid markers on them
* **Interaction with other addons:** The addon may not behave well with
other addons that also change the target frame layout or behavior, but
these incompatibilities may be addressed in future versions, especially
when users report them

## Known issues

This is a list of known issues that players may encounter when using the
addon that are already being addressed and will be fixed in future versions:

* **Raid markers mismatch:** When the player removes a name from the target 
list, the raid markers priorities are recalculated, but the addon won't be 
able to update the current marked enemies, so for a short amount of time, 
the raid markers may not match the target list.
* **Target window scrollbar and empty spaces:** When a list has targets 
enough to enable the window scrollbar, once targets are removed, the 
scrollbar may not reflect the actual number of targets, and empty spaces may 
appear in the end of the window. That's not a blocker issue that prevents the 
addon from working, but it's a visual glitch that will be fixed in future 
versions.

## Changelog

### 2024.05.08 - version 1.2.0

* Improvements to the addon first initialization, by adding the macro even 
with an empty target list
* Fix an annoying case where players remove the last target from the list but
the macro would still try to target the last name, considering that it wasn't
updated for empty lists

#### 2024.05.07 - version 1.1.1

* Add multiple TOC files to support Classic Era, Classic Cataclysm, and
Retail
* Addon settings are now saved per character, which means target lists are not
shared between characters anymore
* Fix a bug that was parsing commands with mixed quotes incorrectly, like `/multitargets add "Vilnak'dor"`

### 2024.04.27 - version 1.1.0

* A new frame to manage the target list with the current target names, their
associated raid markers and remove buttons

#### 2024.04.25 - version 1.0.1

* Broadcast the target list refresh event so integrated addons can run their
own actions when the target list is updated
* Fix a bug where the target frame button was not being updated after adding
or removing targets via chat commands

### 2024.04.10 - version 1.0.0

* Fix a bug where dead units were being targetted
* Fix a bug where units got their marks removed during target rotation
* Friendly chat output messages for all addon commands

### 2024.03.29 - version 0.0.1-alpha

* First addon version with:
   * Target list management with chat commands
   * Target frame button to add and remove the current target to the list
   * Automatic macro creation with the target list names
   * Target rotation system
   * Automatic raid markers on targets