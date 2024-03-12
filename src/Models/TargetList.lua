--[[
The target list model represents a list of targets that can rotate for
multiple /tar options.
]]

local TargetList = {}
TargetList.__index = TargetList

--[[
Target list constructor.
]]
function TargetList.__construct(listName)
    local self = setmetatable({}, TargetList)

    self.current = nil
    self.listName = listName
    self.targets = {}

    return self
end

--[[
Loads the current target index.
]]
function TargetList:loadCurrentIndex()
    self.current = MultiTargets.__.arr:get(MultiTargets_Data, 'lists.' .. self.listName .. '.current')
end

--[[
Loads a list of target instances by looking into the addon data.

When called, this method will replace the inner targets property with the
list of targets identified by the list name argument.
]]
function TargetList:loadTargets()
    local arr = MultiTargets.__.arr

    local targetList = arr:get(MultiTargets_Data, 'lists.' .. self.listName .. '.targets')

    self.targets = arr:map(targetList, function (targetName)
        return MultiTargets.__:new('MultiTargetsTarget', targetName)
    end)
end

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)