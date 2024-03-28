--[[
The target model represents a target instance in a multi target context.

Don't confuse this class with the Target facade in the Stormwind Library.
This one is just a way to objectify a stored target.
]]
local Target = {}
    Target.__index = Target

    --[[
    Target constructor.
    ]]
    function Target.__construct(name)
        local self = setmetatable({}, Target)

        self.name = name
        self.raidMarker = MultiTargets.__.raidMarkers.skull

        return self
    end

    --[[
    Overrides the __eq() method to make sure == operator will be able to
    compare two target instances and determine if they're the same.
    ]]
    function Target:__eq(target)
        return target.name == self.name
    end

    --[[
    Builds the macro body that will target the unit represented by the name
    stored in this instance.
    ]]
    function Target:getMacroBody()
        return {
            '/cleartarget',
            '/target [nodead] ' .. self.name,
            "/run MultiTargets:invokeOnCurrent('maybeMark')",
            '/run C_Timer.After(0.1, function() MultiTargets:rotate() end)',
        }
    end

    --[[
    Gets a printable version of this target.
    ]]
    function Target:getPrintableString()
        local printableString = ''

        if self.raidMarker then
            printableString = self.raidMarker:getPrintableString() .. ' '
        end

        return printableString .. self.name
    end

    --[[
    Determines whether this target instance is the current player target
    in game.

    @TODO: This method should be improved in the future to allow comparing
           partial names, but this need more clarification of which parts
           the /tar command will be able to match. <2024.03.14>

    @treturn boolean
    ]]
    function Target:isTargetted()
        return MultiTargets.__.target:getName() == self.name
    end

    --[[
    Marks the target using the raid marker set for this instance.

    It's important to mention that this method will respect game's rules for
    targeting, which means it won't mark a player from the opposite faction
    for example.

    @codeCoverageIgnore won't have a unit test created for this one due to use
                        only methods already tested and also due to mocking
                        limitations at this point.
    ]]
    function Target:mark()
        MultiTargets.__.target:mark(self.raidMarker)
    end

    --[[
    Marks the target if it should be marked.

    @treturn true if mark() is called.
    ]]
    function Target:maybeMark()
        if self:shouldMark() then
            self:mark()
            return true
        end

        return false
    end

    --[[
    Sets the raid marker for this target.

    The list of available markers can be found in the Stormwind Library.

    @tparam RaidMarker raidMarker

    @treturn self
    ]]
    function Target:setRaidMarker(raidMarker)
        self.raidMarker = raidMarker
        return self
    end

    --[[
    Determines whether the target should be marked or not.

    This method can grow in the future with other conditionals, but for now
    it's just checking if the target is taggable or not. A taggable target
    is a target that's not taggable by another player.

    @treturn boolean
    ]]
    function Target:shouldMark()
        return
            self:isTargetted()
            and MultiTargets.__.target:isTaggable()
    end

    --[[
    Adds or update the main addon class, which is responsible for targeting one
    predefined target name and then rotate to the next one.

    @codeCoverageIgnore won't have a unit test created for this one due to use
                        only methods already tested and also due to mocking
                        limitations at this point.
    ]]
    function Target:updateMacro()
        local macro = MultiTargets.__:new('Macro', 'MultiTargetsMacro')

        macro:setIcon('ability_hunter_focusedaim')
        macro:setBody(self:getMacroBody())
        macro:save()
    end
-- end of Target

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTarget', Target)