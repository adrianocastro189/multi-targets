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

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTarget', Target)