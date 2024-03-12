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

    return self
end

--[[
Builds the macro body that will target the unit represented by the name
stored in this instance.
]]
function Target:getMacroBody()
    return {
        '/cleartarget',
        '/target [nodead] ' .. self.name,
        '/script __h = UnitHealth("target") == UnitHealthMax("target")',
        '/script if __h then SetRaidTarget("target",8) end',
        '/run C_Timer.After(0.1, function() SQRN_NextTarget() end)',
    }
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

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTarget', Target)