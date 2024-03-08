--[[
The target model represents a target instance in a multi target context.
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