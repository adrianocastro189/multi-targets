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

1. **Farming:** Players can create a target list with the names of
   the mobs they want to farm in a specific area.
1. **Hunting rares:** Players can create a target list with the names
   of the rares they want to hunt in a specific zone instead of
   manually upating the macro with the names of the current rare
   being hunted.
1. **Questing:** When players need to kill specific mobs for a quest,
   they can create a target list with the names of these mobs, so
   it's easier to target them, especially when the quest requires
   killing more than one type of enemy.
1. **Raiding and in dungeons:** Players can create a target list
   with the names of the mobs they need to focus on, like the ones
   that need to be interrupted or killed first, then a single key
   binding can be used to target them in sequence.

## How to use this addon

![A Defias being targetted](https://i.imgur.com/iaXC0qn.png "A Defias being targetted")

1. Install and enable the addon
1. Once you log in, the addon will load the default target list
and it's ready to be used and populated with names
1. There are a couple of ways to add names to the target list:
   * **Using the target frame button:** Click on the target frame
      button to add the name of the current target to the target list
   * **Using the chat command:** Type `/multitargets add` followed by the
      name of the target to add it to the target list
   * **Adding the current target with a command:** When the target
      is selected, type `/multitargets addt` to add the name of the
      current target to the target list
1. Once the first name is added to the target list, the addon will
   automatically create a macro called **MultiTargetsMacro** with the
   arrows and an aim icon. Just drag this macro to your action bar.
1. Now it's a matter of spamming the macro key binding to rotate
   through the names in the target list.

## Available commands

All command line options are available using the `/multitargets` command.

In the addon's first versions, most of its functionalities are available
through the chat command. The addon will have a graphical interface in
the future, but for now, the chat command is the best way to interact
with it.

![A print command example](https://i.imgur.com/WWRhFj0.png "A print command example")

These are the available commands:

* `/multitargets add <name>`: Adds the given name to the target list
* `/multitargets addt`: Adds the name of the player's current target to
the target list, replacing `<name>` with any name and wrapping it with
quotes if it has spaces
* `/multitargets clear`: Clears the target list
* `/multitargets help`: Shows the available commands
* `/multitargets print`: Prints the names in the target list
* `/multitargets remove <name>`: Removes the given name from the target
list, replacing `<name>` with any name and wrapping it with
quotes if it has spaces
* `/multitargets removet`: Removes the name of the player's current target
from the target list

## What's on the roadmap for the next versions

* **Visual target list editor:** A graphical interface to manage the
target list with buttons to add, remove, and clear names
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

* **Raid markers gone when targeting a marked mob:** When the player targets
a mob that is already marked, the raid marker will disappear, as the addon
will try to mark the mob again
* **Raid markers mismatch:** When the player removes a name from the target list,
the raid markers priorities are recalculated, but the addon won't be able to
update the current marked enemies, so for a short amount of time, the raid
markers may not match the target list

## Changelog

### yyyy.mm.dd - version 0.0.1-alpha

* First addon version with:
   * Target list management with chat commands
   * Target frame button to add and remove the current target to the list
   * Automatic macro creation with the target list names
   * Target rotation system
   * Automatic raid markers on targets