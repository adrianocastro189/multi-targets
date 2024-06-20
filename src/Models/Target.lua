--[[
The target model represents a target instance in a multi target context.

Don't confuse this class with the Target facade in the Stormwind Library.
This one is just a way to objectify a stored target.
]]
local Target = {}
    Target.__index = Target

    --[[
    Target constructor.
    
    The target parameter can be either a string with the target name or a
    Target instance. This is useful for avoiding multiple repeated
    conditionals in the addon code for methods that expect a target instance
    or a single target name that needs to be objectified. Note that only the
    primary target properties will be extracted from the parameter if it's a
    object instance - in other words, the complete target instance won't be
    copied to this instance.

    @tparam string|Target target The target name or a Target instance
    ]]
    function Target.__construct(target)
        local self = setmetatable({}, Target)

        -- @NOTE: If new properties are allowed to be added to this class,
        --        then an auxiliary method should be created to handle the
        --        instantiation of this class.
        self.name = type(target) == 'string' and target or target.name

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
            '/target ' .. self.name,
            '/cleartarget [dead]',
            "/run MultiTargets:invokeOnCurrent('maybeMark')",
            "/run C_Timer.After(0.1, function() MultiTargets:invokeOnCurrent('rotate') end)",
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
    Determines whether this target instance is already marked in game.

    An important observation to make: this method checks if the target is
    marked with the same raid marker set in this instance. In case you want
    to check if the target is marked with any raid marker, you should use
    the Stormwind Library's Target facade.

    @treturn boolean
    ]]
    function Target:isAlreadyMarked()
        local targetMarker = MultiTargets.__.target:getMark()

        return
            targetMarker ~= nil
            and self.raidMarker ~= nil
            and targetMarker == self.raidMarker
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
    Determines whether the target should be marked or not based on the
    conditions for a target to be marked.

    The not self:isAlreadyMarked() check is important to avoid marking the
    same target again, which in game would mean removing the mark.

    @treturn boolean
    ]]
    function Target:shouldMark()
        return
            self:isTargetted()
            and not self:isAlreadyMarked()
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
        MultiTargets.__
            :new('MultiTargets/Macro')
            :updateMacro(self:getMacroBody())
    end
-- end of Target

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTarget', Target)