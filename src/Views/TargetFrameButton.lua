local TargetFrameButton = {}
    TargetFrameButton.__index = TargetFrameButton

    --[[
    TargetFrameButton constructor.
    ]]
    function TargetFrameButton.__construct()
        local self = setmetatable({}, TargetFrameButton)

        self:createButton()
        self:observeTargetChanges()
        self:turnAddState()

        return self
    end

    --[[
    Creates the button that will be added to the player's target frame.

    @codeCoverageIgnore this method is already tested in the constructor
                        test, so it is not necessary to test it again,
                        unless there's a good mock expectation structure
                        in the future
    ]]
    function TargetFrameButton:createButton()
        self.button = CreateFrame("Button", "TargetFrameButton", TargetFrame, "UIPanelButtonTemplate")
        self.button:SetSize(75, 25)
        self.button:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 3, 0)
        self.button:SetScript('OnClick', function ()
            self:onButtonClick()
        end)
    end

    --[[
    Determines if the button is in the adding state.

    @treturn boolean
    ]]
    function TargetFrameButton:isAdding()
        return self.state == 'adding'
    end

    --[[
    Determines if the button is in the removing state.

    @treturn boolean
    ]]
    function TargetFrameButton:isRemoving()
        return self.state == 'removing'
    end

    --[[
    Observes the target changes in the game.

    When the player changes the target, the button's state will be updated.
    ]]
    function TargetFrameButton:observeTargetChanges()
        local callback = function() self:updateState() end

        MultiTargets.__.events:listen('PLAYER_TARGET', callback)
        MultiTargets.__.events:listen('PLAYER_TARGET_CHANGED', callback)
    end

    --[[
    Callback for the button's click event.
    ]]
    function TargetFrameButton:onButtonClick()
        if self:isAdding() then
            MultiTargets:invokeOnCurrent('addTargetted')
        else
            -- this is the only other state, so we don't need to check
            -- if it's removing, however, we could add a check here
            -- if we add more states in the future
            MultiTargets:removeTargetted()
        end

        self:updateState()
    end

    --[[
    Updates the button's state to adding.
    ]]
    function TargetFrameButton:turnAddState()
        local skullMark = MultiTargets.__.raidMarkers.skull

        self.button:SetText(skullMark:getPrintableString() .. ' Add')
        self.state = 'adding'
    end

    --[[
    Updates the button's state to removing.
    ]]
    function TargetFrameButton:turnRemoveState()
        local xMark = MultiTargets.__.raidMarkers.x

        self.button:SetText(xMark:getPrintableString() .. ' Remove')
        self.state = 'removing'
    end

    --[[
    Updates the button's state based on the current target.
    
    If the current target is in the target list, the button will be in the
    removing state, otherwise, it will be in the adding state.
    ]]
    function TargetFrameButton:updateState()
        local targetName = MultiTargets.__.target:getName()

        if not targetName then return end

        if MultiTargets.currentTargetList:has(targetName) then
            self:turnRemoveState()
            return
        end

        self:turnAddState()
    end
-- end of TargetFrameButton

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetFrameButton', TargetFrameButton)