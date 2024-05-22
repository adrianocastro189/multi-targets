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

        local inserted = MultiTargets.__.arr:insertNotInArray(self.targets, MultiTargets.__:new('MultiTargetsTarget', name))

        MultiTargets:out(inserted
            and (name .. ' added to the target list')
            or  (name .. ' is already in the target list'))
        
        self:refreshState()
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

        MultiTargets:out('Target list cleared successfully')
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
        return MultiTargets.__.arr:inArray(
            self.targets,
            MultiTargets.__:new('MultiTargetsTarget', target)
        )
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
        self:refreshState()
    end

    --[[
    Loads the current target index.
    ]]
    function TargetList:loadCurrentIndex()
        self.current = MultiTargets.__:playerConfig(self.currentDataKey)
    end

    --[[
    Loads a list of target instances by looking into the addon data.

    When called, this method will replace the inner targets property with the
    list of targets identified by the list name argument.
    ]]
    function TargetList:loadTargets()
        local arr = MultiTargets.__.arr

        local targetList = MultiTargets.__:playerConfig(self.targetsDataKey)

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
        MultiTargets.__:playerConfig(self.targetsDataKey, {}, true)
        MultiTargets.__:playerConfig(self.currentDataKey, 0, true)
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
        if self:isEmpty() then
            MultiTargets:out('There are no targets in the target list')
            return
        end

        MultiTargets.__.arr:map(self.targets, function (target, i)
            MultiTargets:out('Target #' .. i .. ' - ' .. target:getPrintableString())
        end)
    end

    --[[
    Refreshes the state of the target list.

    By refreshing the state, this method will make sure that the current
    state of this instance reflects the changes. It must be executed after
    adding or removing targets and serves as a central update point for
    other possible changes in the future.

    This method also broadcasts the TARGET_LIST_REFRESHED event to let
    observers know that the target list has changed.

    @local

    @tparam string action The action that triggered the refresh
    ]]
    function TargetList:refreshState(action)
        self:sanitizeCurrent()
        self:sanitizeMarks()
        self:updateMacroWithCurrentTarget()
        self:save()

        -- broadcasts the event to let observers know that the target
        -- list has changed
        MultiTargets.__.events:notify('TARGET_LIST_REFRESHED', self, action)
    end

    --[[
    Removes a target from the target list.

    This method also sanitizes the current index and saves the list data.
    ]]
    function TargetList:remove(name)
        if MultiTargets.__.str:isEmpty(name) then
            MultiTargets:out('Invalid target name')
            return
        end

        local removed = MultiTargets.__.arr:remove(self.targets, MultiTargets.__:new('MultiTargetsTarget', name))

        MultiTargets:out(removed
            and (name .. ' removed from the target list')
            or  (name .. ' is not in the target list'))

        self:refreshState()
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

        self:refreshState()
    end

    --[[
    May adjust the current index based on a couple of conditions to keep the
    current as a valid information for this class execution.
    ]]
    function TargetList:sanitizeCurrent()
        if self:isEmpty() then self.current = 0 return end

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

    This method only updates the configuration.
    
    According to the World of Warcraft addons architecture, the data will be
    really saved only when the user logs off.
    ]]
    function TargetList:save()
        local arr = MultiTargets.__.arr

        MultiTargets.__:playerConfig({[self.targetsDataKey] = arr:pluck(self.targets, 'name')})
        MultiTargets.__:playerConfig({[self.currentDataKey] = self.current})
    end

    --[[
    This method will call the current target updateMacro() method in case the
    current index is valid.
    ]]
    function TargetList:updateMacroWithCurrentTarget()
        -- sanity check
        if not self:currentIsValid() then
            self:updateMacroWithDefault()
            return
        end

        self.targets[self.current]:updateMacro()
    end

    --[[
    Updates the macro with a friendly message to players indicating that the
    target list is empty.
    ]]
    function TargetList:updateMacroWithDefault()
        MultiTargets.__
        :new('MultiTargetsMacro')
        :updateMacro("/run MultiTargets:out('There are no names in the target list')")
    end
-- end of TargetList

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetList', TargetList)