--[[
The AbstractTargetFrameButton implementation for classic clients.
]]
local ClassicTargetFrameButton = {}
ClassicTargetFrameButton.__index = ClassicTargetFrameButton
    MultiTargets.__:addChildClass('MultiTargets/TargetFrameButton', ClassicTargetFrameButton, 'MultiTargets/AbstractTargetFrameButton', {
        MultiTargets.__.environment.constants.TEST_SUITE,
        MultiTargets.__.environment.constants.CLIENT_CLASSIC_ERA,
        MultiTargets.__.environment.constants.CLIENT_CLASSIC,
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