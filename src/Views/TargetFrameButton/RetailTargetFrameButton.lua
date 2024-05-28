--[[--
]]
local RetailTargetFrameButton = {}
RetailTargetFrameButton.__index = RetailTargetFrameButton
    -- RetailTargetFrameButton inherits from AbstractTargetFrameButton
    setmetatable(RetailTargetFrameButton, MultiTargets.__:getClass('MultiTargetsAbstractTargetFrameButton'))
    MultiTargets.__:addClass('MultiTargetsRetailTargetFrameButton', RetailTargetFrameButton, MultiTargets.__.environment.constants.TEST_SUITE)
    MultiTargets.__:addClass('MultiTargetsTargetFrameButton', RetailTargetFrameButton, {
        MultiTargets.__.environment.constants.CLIENT_RETAIL,
    })

    --[[--
    RetailTargetFrameButton constructor.
    ]]
    function RetailTargetFrameButton.__construct()
        return setmetatable({}, RetailTargetFrameButton)
    end
-- end of RetailTargetFrameButton