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

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTarget', Target)