--[[
The AbstractTargetFrameButton implementation for classic clients.
]]
local ClassicTargetFrameButton = {}
ClassicTargetFrameButton.__index = ClassicTargetFrameButton
    MultiTargets:addChildClass('MultiTargets/TargetFrameButton', ClassicTargetFrameButton, 'MultiTargets/AbstractTargetFrameButton', {
        MultiTargets.environment.constants.TEST_SUITE,
        MultiTargets.environment.constants.CLIENT_CLASSIC_ERA,
        MultiTargets.environment.constants.CLIENT_CLASSIC,
    })

    --[[
    ClassicTargetFrameButton constructor.
    ]]
    function ClassicTargetFrameButton.__construct()
        return setmetatable({}, ClassicTargetFrameButton)
    end

    --[[
    @inheritDoc
    @codeCoverageIgnore
    ]]
    function ClassicTargetFrameButton:getOffset()
        return 5, 5
    end
-- end of ClassicTargetFrameButton