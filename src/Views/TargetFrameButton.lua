local TargetFrameButton = {}
    TargetFrameButton.__index = TargetFrameButton

    --[[
    TargetFrameButton constructor.
    ]]
    function TargetFrameButton.__construct()
        local self = setmetatable({}, TargetFrameButton)

        self:createButton()
        self.state = 'adding'

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
        self.button:SetSize(100, 30)
        self.button:SetText("Add")
        self.button:SetPoint("TOPRIGHT", TargetFrame, "TOPRIGHT", 0, 0)
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
    Callback for the button's click event.
    ]]
    function TargetFrameButton:onButtonClick()
        if self:isAdding() then
            MultiTargets:addTargetted()
        else
            -- this is the only other state, so we don't need to check
            -- if it's removing, however, we could add a check here
            -- if we add more states in the future
            MultiTargets:removeTargetted()
        end

        -- @TODO: uncomment this line
        -- self:updateState()
    end
-- end of TargetFrameButton

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetFrameButton', TargetFrameButton)