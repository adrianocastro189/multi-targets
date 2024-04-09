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

        -- data keys
        self.targetsDataKey = 'lists.' .. self.listName .. '.targets'
        self.currentDataKey = 'lists.' .. self.listName .. '.current'

        return self
    end

    --[[
    Adds a target to the list.

    This method won't add duplicate names.

    @tparam string name
    ]]
    function TargetList:add(name)
        if MultiTargets.__.str:isEmpty(name) then
            MultiTargets:out('Invalid target name')
            return
        end

        MultiTargets.__.arr:insertNotInArray(self.targets, MultiTargets.__:new('MultiTargetsTarget', name))
        self:sanitizeCurrent()
        self:sanitizeMarks()
        self:updateMacroWithCurrentTarget()
        self:save()
    end

    --[[
    Adds the current target in the game to the target list.

    If the player has no target, this method won't add anything.
    ]]
    function TargetList:addTargetted()
        local targetName = MultiTargets.__.target:getName()

        if targetName then self:add(targetName) end
    end

    --[[
    Clears the target list.
    ]]
    function TargetList:clear()
        self.targets = {}
        self.current = 0
        self:save()
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
    Determines whether the target list has a target.

    This method accepts both a string name or a target instance.

    @tparam string|Target target
    @treturn boolean
    ]]
    function TargetList:has(target)
        if type(target) == 'string' then
            target = MultiTargets.__:new('MultiTargetsTarget', target)
        end

        return MultiTargets.__.arr:inArray(self.targets, target)
    end

    --[[
    Determines whether the target list is empty.

    @treturn boolean
    ]]
    function TargetList:isEmpty()
        return #self.targets == 0
    end

    --[[
    Loads all the information for this target list.
    ]]
    function TargetList:load()
        self:maybeInitializeData()
        self:loadTargets()
        self:loadCurrentIndex()
        self:sanitizeCurrent()
        self:sanitizeMarks()
        self:updateMacroWithCurrentTarget()
    end

    --[[
    Loads the current target index.
    ]]
    function TargetList:loadCurrentIndex()
        self.current = MultiTargets.__.arr:get(MultiTargets_Data, self.currentDataKey)
    end

    --[[
    Loads a list of target instances by looking into the addon data.

    When called, this method will replace the inner targets property with the
    list of targets identified by the list name argument.
    ]]
    function TargetList:loadTargets()
        local arr = MultiTargets.__.arr

        local targetList = arr:get(MultiTargets_Data, self.targetsDataKey)

        self.targets = arr:map(targetList, function (targetName)
            return MultiTargets.__:new('MultiTargetsTarget', targetName)
        end)
    end

    --[[
    May initialize the data for this target list.

    This method is responsible for setting an empty list of targets and the
    current index to zero in case the data is not already set. This will
    guarantee that the target list is always in a valid state in terms of
    persisted data.
    ]]
    function TargetList:maybeInitializeData()
        MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, self.targetsDataKey, {})
        MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, self.currentDataKey, 0)
    end

    --[[
    Iterates over all targets in this list and attempt to mark the one
    that's target by the player.
    ]]
    function TargetList:maybeMark()
        for index, target in ipairs(self.targets) do
            if (target:maybeMark()) then return end
        end
    end

    --[[
    Prints the target list.
    ]]
    function TargetList:print()
        MultiTargets.__.arr:map(self.targets, function (target, i)
            MultiTargets:out('Target #' .. i .. ' - ' .. target:getPrintableString())
        end)
    end

    --[[
    Removes a target from the target list.

    This method also sanitizes the current index and saves the list data.
    ]]
    function TargetList:remove(name)
        MultiTargets.__.arr:remove(self.targets, MultiTargets.__:new('MultiTargetsTarget', name))
        self:sanitizeCurrent()
        self:sanitizeMarks()
        self:updateMacroWithCurrentTarget()
        self:save()
    end

    --[[
    Removes the current target from the target list.

    If the player has no target, this method won't add anything.
    ]]
    function TargetList:removeTargetted()
        local targetName = MultiTargets.__.target:getName()

        if targetName then self:remove(targetName) end
    end

    --[[
    The rotation method that will try to select the next target and update the
    macro to use a new /tar command.
    ]]
    function TargetList:rotate()
        self.current = self.current + 1

        self:sanitizeCurrent()
        self:updateMacroWithCurrentTarget()
        self:save()
    end

    --[[
    May adjust the current index based on a couple of conditions to keep the
    current as a valid information for this class execution.
    ]]
    function TargetList:sanitizeCurrent()
        if self:isEmpty() then self.current = 0 end

        if self:currentIsValid() then return end

        self.current = 1
    end

    --[[
    Sanitizes the marks of all targets in the list.

    This method will iterate over all targets and determine the most appropriate
    mark for each one based on the current target index.
    ]]
    function TargetList:sanitizeMarks()
        local repository = MultiTargets.markerRepository
        MultiTargets.__.arr:map(self.targets, function (target, index)
            target:setRaidMarker(repository:getRaidMarkerByTargetIndex(index))
        end)
    end

    --[[
    Saves the list data.

    This method only updates the MultiTargets_Data array. According to the
    World of Warcraft addons architecture, the data will be really saved only
    when the user logs off.
    ]]
    function TargetList:save()
        local arr = MultiTargets.__.arr

        arr:set(MultiTargets_Data, self.targetsDataKey, arr:pluck(self.targets, 'name'))
        arr:set(MultiTargets_Data, self.currentDataKey, self.current)
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
-- end of TargetList

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)