--[[
The AbstractTargetFrameButton class is responsible for creating and managing
the button that will be attached to the player's target frame, which is that
small frame that appears when the player targets a unit in the game (another
player, an enemy, a friendly NPC, etc).

The button may assume two states: adding and removing, based on the current
target existence in the target list. When the player targets a unit that is
not in the target list, the button will be in the adding state, and when the
player targets a unit that is in the target list, the button will be in the
removing state.

As an event listener, the button may update its state when the player changes
the target list, regardless of the change source.
]]
local AbstractTargetFrameButton = {}
    AbstractTargetFrameButton.__index = AbstractTargetFrameButton

    --[[
    AbstractTargetFrameButton constructor.
    ]]
    function AbstractTargetFrameButton.__construct()
        return setmetatable({}, AbstractTargetFrameButton)
    end

    --[[
    Creates the button that will be added to the player's target frame.

    @codeCoverageIgnore this method is already tested in the constructor
                        test, so it is not necessary to test it again,
                        unless there's a good mock expectation structure
                        in the future
    ]]
    function AbstractTargetFrameButton:createButton()
        self.button = CreateFrame("Button", "TargetFrameButton", TargetFrame, "UIPanelButtonTemplate")
        self.button:SetSize(75, 25)
        self.button:SetPoint("TOPLEFT", TargetFrame, "TOPLEFT", 3, 0)
        self.button:SetScript('OnClick', function ()
            self:onButtonClick()
        end)
    end

    --[[
    Gets the button offset from the target frame.

    This method is used to position the button in the target frame and it's
    abstract due to the different offsets that the button may have in the
    World of Warcraft clients.
    ]]
    function AbstractTargetFrameButton:getOffset()
        error('This is an abstract method and should be implemented by this class inheritances')
    end

    --[[
    Initializes the class dependencies.

    This method was originally part of the constructor execution, but since
    the target frame button became an abstract class, it was moved to a
    separate method to be called by the inheritances as constructor override
    is not entirely supported by the Stormwind Library class factory
    structure.
    ]]
    function AbstractTargetFrameButton:initialize()
        self:createButton()
        self:observeTargetChanges()
        self:turnAddState()
    end

    --[[
    Determines if the button is in the adding state.

    @treturn boolean
    ]]
    function AbstractTargetFrameButton:isAdding()
        return self.state == 'adding'
    end

    --[[
    Determines if the button is in the removing state.

    @treturn boolean
    ]]
    function AbstractTargetFrameButton:isRemoving()
        return self.state == 'removing'
    end

    --[[
    Observes the target changes in the game.

    When the player changes the target, the button's state will be updated.
    ]]
    function AbstractTargetFrameButton:observeTargetChanges()
        local callback = function() self:updateState() end

        MultiTargets.__.events:listen('PLAYER_TARGET', callback)
        MultiTargets.__.events:listen('PLAYER_TARGET_CHANGED', callback)
        MultiTargets.__.events:listen('TARGET_LIST_REFRESHED', callback)
    end

    --[[
    Callback for the button's click event.
    ]]
    function AbstractTargetFrameButton:onButtonClick()
        if self:isAdding() then
            MultiTargets:invokeOnCurrent('addTargetted')
        else
            -- this is the only other state, so we don't need to check
            -- if it's removing, however, we could add a check here
            -- if we add more states in the future
            MultiTargets:invokeOnCurrent('removeTargetted')
        end

        self:updateState()
    end

    --[[
    Updates the button's state to adding.
    ]]
    function AbstractTargetFrameButton:turnAddState()
        local skullMark = MultiTargets.__.raidMarkers.skull

        self.button:SetText(skullMark:getPrintableString() .. ' Add')
        self.state = 'adding'
    end

    --[[
    Updates the button's state to removing.
    ]]
    function AbstractTargetFrameButton:turnRemoveState()
        local xMark = MultiTargets.__.raidMarkers.x

        self.button:SetText(xMark:getPrintableString() .. ' Remove')
        self.state = 'removing'
    end

    --[[
    Updates the button's state based on the current target.
    
    If the current target is in the target list, the button will be in the
    removing state, otherwise, it will be in the adding state.
    ]]
    function AbstractTargetFrameButton:updateState()
        local targetName = MultiTargets.__.target:getName()

        if not targetName then return end

        if MultiTargets.currentTargetList:has(targetName) then
            self:turnRemoveState()
            return
        end

        self:turnAddState()
    end
-- end of AbstractTargetFrameButton

-- allows this class to be extended by registering it to the factory
MultiTargets.__:addClass('MultiTargetsAbstractTargetFrameButton', AbstractTargetFrameButton)