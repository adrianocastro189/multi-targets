--[[
The AbstractTargetFrameButton implementation for classic clients.
]]
local ClassicTargetFrameButton = {}
ClassicTargetFrameButton.__index = ClassicTargetFrameButton
    -- ClassicTargetFrameButton inherits from AbstractTargetFrameButton
    setmetatable(ClassicTargetFrameButton, MultiTargets.__:getClass('MultiTargetsAbstractTargetFrameButton'))
    MultiTargets.__:addClass('MultiTargetsClassicTargetFrameButton', ClassicTargetFrameButton, MultiTargets.__.environment.constants.TEST_SUITE)
    MultiTargets.__:addClass('MultiTargetsTargetFrameButton', ClassicTargetFrameButton, {
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