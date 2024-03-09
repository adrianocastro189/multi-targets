--[[
The target list model represents a list of targets that can rotate for
multiple /tar options.
]]

local TargetList = {}
TargetList.__index = TargetList

--[[
Target list constructor.
]]
function TargetList.__construct()
    return setmetatable({}, TargetList)
end

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)