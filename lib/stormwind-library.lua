
if (StormwindLibrary_v0_0_6) then return end
        
StormwindLibrary_v0_0_6 = {}
StormwindLibrary_v0_0_6.__index = StormwindLibrary_v0_0_6

function StormwindLibrary_v0_0_6.new()
    local self = setmetatable({}, StormwindLibrary_v0_0_6)
    -- Library version = '0.0.6'

--[[
Contains a list of classes that can be instantiated by the library.
]]
self.classes = {}

--[[
Registers a class so the library is able to instantiate it later.

This method's the same as updating self.classes.
]]
function self:addClass(classname, classStructure)
    self.classes[classname] = classStructure
end

--[[
This method emulates the new keyword in OOP languages by instantiating a
class by its name as long as the class has a __construct() method with or
without parameters.
]]
function self:new(classname, ...)
    return self.classes[classname].__construct(...)
end

--[[
The target facade maps all the information that can be retrieved by the
World of Warcraft API target related methods.

This class can also be used to access the target with many other purposes,
like setting the target icon.
]]

local Target = {}
Target.__index = Target

--[[
Target constructor.
]]
function Target.__construct()
    local self = setmetatable({}, Target)

    return self
end

--[[
Gets the target GUID.
]]
function Target:getGuid()
    return UnitGUID('target')
end

--[[
Gets the target health.

In the World of Warcraft API, the UnitHealth('target') function behaves
differently for NPCs and other players. For NPCs, it returns the absolute
value of their health, whereas for players, it returns a value between
0 and 100 representing the percentage of their current health compared
to their total health.
]]
function Target:getHealth()
    return self:hasTarget() and UnitHealth('target') or nil
end

--[[
Gets the target health in percentage.

This method returns a value between 0 and 1, representing the target's
health percentage.
]]
function Target:getHealthPercentage()
    return self:hasTarget() and (self:getHealth() / self:getMaxHealth()) or nil
end

--[[
Gets the maximum health of the specified unit.

In the World of Warcraft API, the UnitHealthMax function is used to
retrieve the maximum health of a specified unit. When you call
UnitHealthMax('target'), it returns the maximum amount of health points
that the targeted unit can have at full health. This function is commonly
used by addon developers and players to track and display health-related
information, such as health bars and percentages.
]]
function Target:getMaxHealth()
    return self:hasTarget() and UnitHealthMax('target') or nil
end

--[[
Gets the target name.
]]
function Target:getName()
    return UnitName('target')
end

--[[
Determines whether the player has a target or not.
]]
function Target:hasTarget()
    return nil ~= self:getName()
end

--[[
Determines whether the target is alive.
]]
function Target:isAlive()
    if self:hasTarget() then
        return not self:isDead()
    end
    
    return nil
end

--[[
Determines whether the target is dead.
]]
function Target:isDead()
    return self:hasTarget() and UnitIsDeadOrGhost('target') or nil
end

--[[
Determines whether the target is taggable or not.

In Classic World of Warcraft, a taggable enemy is an enemy is an enemy that
can grant experience, reputation, honor, loot, etc. Of course, that would
depend on the enemy level, faction, etc. But this method checks if another
player hasn't tagged the enemy before the current player.

As an example, if the player targets an enemy with a gray health bar, it
means it's not taggable, then this method will return false.
]]
function Target:isTaggable()
    if not self:hasTarget() then
        return nil
    end

    return not self:isNotTaggable()
end

--[[
Determines whether the target is already tagged by other player.

Read Target::isTaggable() method's documentation for more information.
]]
function Target:isNotTaggable()
    return UnitIsTapDenied('target')
end

--[[
Adds or removes a marker on the target based on a target icon index:

0 - Removes any icons from the target
1 = Yellow 4-point Star
2 = Orange Circle
3 = Purple Diamond
4 = Green Triangle
5 = White Crescent Moon
6 = Blue Square
7 = Red "X" Cross
8 = White Skull

@see https://wowwiki-archive.fandom.com/wiki/API_SetRaidTarget
]]
function Target:mark(iconIndex)
    SetRaidTarget('target', iconIndex)
end

-- sets the unique library target instance
self.target = Target.__construct()
function self:getTarget() return self.target end

local Macro = {}
Macro.__index = Macro
Macro.__ = self
self:addClass('Macro', Macro)

--[[
Macro constructor.

@tparam string name the macro's name
]]
function Macro.__construct(name)
    local self = setmetatable({}, Macro)

    self.name = name

    -- defaults
    self:setIcon("INV_Misc_QuestionMark")

    return self
end

--[[
Determines whether this macro exists.

@treturn boolean
]]
function Macro:exists()
    return GetMacroIndexByName(self.name) > 0
end

--[[
Saves the macro, returning the macro id.

If the macro, identified by its name, doesn't exist yet, it will be created.

It's important to mention that this whole Macro class can have weird
behavior if it tries to save() a macro with dupicated names. Make sure this
method is called for unique names.

Future implementations may fix this issue, but as long as it uses unique
names, this model will work as expected.

@treturn integer the macro id
]]
function Macro:save()
    if self:exists() then
        return EditMacro(self.name, self.name, self.icon, self.body)
    end

    return CreateMacro(self.name, self.icon, self.body)
end

--[[
Sets the macro body.

The macro's body is the code that will be executed when the macro's
triggered.

If the value is an array, it's considered a multiline body, and lines will
be separated by a line break.

@tparam array<string>|string value the macro's body

@return self
]]
function Macro:setBody(value)
    self.body = self.__.arr:implode('\n', value)
    return self
end

--[[
Sets the macro icon.

@tparam integer|string value the macro's icon texture id

@return self
]]
function Macro:setIcon(value)
    self.icon = value
    return self
end

--[[
Sets the macro name.

This is the macro's identifier, which means the one World of Warcraft API
will use when accessing the game's macro.

@tparam string value the macro's name

@return self
]]
function Macro:setName(value)
    self.name = value
    return self
end

--[[
The Arr support class contains helper functions to manipulate arrays.
]]
local Arr = {}
Arr.__index = Arr
Arr.__ = self

--[[
Gets a value in an array using the dot notation.

With the dot notation search, it's possible to query a value in a multidimensional array
by passing a single string containing keys separated by dot.
]]
function Arr:get(list, key, default)
    local keys = self.__.str:split(key, '.')
    local current = list[keys[1]]

    for i = 2, #keys do current = current and current[keys[i]] or nil end

    return current or default
end

--[[
Combines the elements of a table into a single string, separated by a
specified delimiter.

@tparam string the delimiter used to separate the elements in the resulting string
@tparam array the table containing elements to be combined into a string

@treturn string
]]
function Arr:implode(delimiter, list)
    if not (self:isArray(list)) then
        return list
    end

    local result = ""
    local length = #list
    for i, v in ipairs(list) do
        result = result .. v
        if i < length then
            result = result .. delimiter
        end
    end
    return result
end

--[[
Determines whether a value is in an array.

If so, returns true and the index, false and 0 otherwise.

Class instances can also be checked in this method, not only primitive
types, as long as they implement the __eq method.

@treturn boolean, int
]]
function Arr:inArray(list, value)
    local results = {}

    for i, val in pairs(list) do
        if val == value then
            return true, i
        end
    end

    return false, 0
end

--[[
Inserts a value in an array if it's not in the array yet.

It's important to mention that this method only works for arrays with
numeric indexes. After all, if using string keys, there's no need to check,
but only setting and replacing the value.

Class instances can also be passed as the value, not only primitive types,
as long as they implement the __eq method.
]]
function Arr:insertNotInArray(list, value)
    if not self:isArray(list) or self:inArray(list, value) then
        return false
    end

    table.insert(list, value)
    return true
end

--[[
Determines whether the value is an array or not.

The function checks whether the parameter passed is a table in Lua.
If it is, it iterates over the table's key-value pairs, examining each key
to determine if it is numeric. If all keys are numeric, indicating an
array-like structure, the function returns true; otherwise, it returns
false.

This strategy leverages Lua's type checking and table iteration
capabilities to ascertain whether the input value qualifies as an array.

@return boolean
]]
function Arr:isArray(value)
    if type(value) == "table" then
        local isArray = true
        for k, v in pairs(value) do
            if type(k) ~= "number" then
                isArray = false
                break
            end
        end
        return isArray
    end
    return false
end

--[[
Iterates over the list values and calls the callback function in the second
argument for each of them.

The callback function must be a function that accepts (val) or (val, i)
where val is the object in the interaction and i it's index.

This method accepts arrays and tables.
]]
function Arr:map(list, callback)
    local results = {}

    for i, val in pairs(list) do results[i] = callback(val, i) end

    return results
end

--[[
Initializes a value in a table if it's not initialized yet.

The key accepts a dot notation key just like get() and set().
]]
function Arr:maybeInitialize(list, key, initialValue)
    if self:get(list, key) == nil then self:set(list, key, initialValue) end
end

--[[
Extracts a list of values from a list of objects based on a given key.

It's important to mention that nil values won't be returned in the
resulted list. Which means: objects that have no property or when their
properties are nil, the values won't be returned. That said, a list with n
items can return a smaller list.

The key accepts a dot notation key just like get() and set().
]]
function Arr:pluck(list, key)
    local results = {}
    for _, item in ipairs(list) do
        table.insert(results, self:get(item, key))
    end
    return results
end

--[[
Sets a value using arrays dot notation.

It will basically iterate over the keys separated by "." and create
the missing indexes, finally setting the last key with the value in
the args list.
]]
function Arr:set(list, key, value)
    local keys = self.__.str:split(key, '.')
    local current = list

    for i = 1, #keys do
        local key = keys[i]

        if i == #keys then
            -- this is the last key, so just the value and return
            current[key] = value
            return
        end

        -- creates an empty table
        if current[key] == nil then current[key] = {} end
        
        -- sets the "pointer" for the next iteration
        current = current[key]
    end
end

self.arr = Arr
--[[
The Str support class contains helper functions to manipulate strings.
]]
local Str = {}
Str.__index = Str

--[[
Splits a string in a table by breaking it where the separator is found.

@tparam string value
@tparam string separator

@treturn table
]]
function Str:split(value, separator)
    local values = {}
    for str in string.gmatch(value, "([^"..separator.."]+)") do
        table.insert(values, str)
    end
    return values
end

self.str = Str
    return self
end