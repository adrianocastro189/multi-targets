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

    self.current = 0
    self.listName = listName
    self.targets = {}

    return self
end

--[[
Determines whether the current index is a valid one.

A valid index is an index that greater than zero and lower than the target
list size, which means it can be used to select a target.

@treturn boolean
]]
function TargetList:currentIsValid()
    return self.current > 0 and self.current <= #self.targets
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

--[[
This method will call the current target updateMacro() method in case the
current index is valid.
]]
function TargetList:updateMacroWithCurrentTarget()
    -- sanity check
    if not self:currentIsValid() then return end
    
    self.targets[self.current]:updateMacro()
end

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)