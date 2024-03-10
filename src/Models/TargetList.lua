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
    local self = setmetatable({}, TargetList)

    self.targets = {}

    return self
end

--[[
Loads a list of target instances by looking into the addon data.

When called, this method will replace the inner targets property with the
list of targets identified by the list name argument.

@tparam string the target list name
]]
function TargetList:load(listName)
    local arr = MultiTargets.__.arr

    local targetList = arr:get(MultiTargets_Data, 'lists.' .. listName .. '.targets')

    self.targets = arr:map(targetList, function (targetName)
        return MultiTargets.__:new('MultiTargetsTarget', targetName)
    end)
end

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)