--[[
The AbstractTargetFrameButton implementation for the retail client.
]]
local RetailTargetFrameButton = {}
RetailTargetFrameButton.__index = RetailTargetFrameButton
    MultiTargets:addChildClass('MultiTargets/TargetFrameButton', RetailTargetFrameButton, 'MultiTargets/AbstractTargetFrameButton', {
        MultiTargets.environment.constants.CLIENT_RETAIL,
    })

    --[[
    RetailTargetFrameButton constructor.
    ]]
    function RetailTargetFrameButton.__construct()
        return setmetatable({}, RetailTargetFrameButton)
    end

    --[[
    @inheritDoc
    @codeCoverageIgnore
    ]]
    function RetailTargetFrameButton:getOffset()
        return 22, 0
    end
-- end of RetailTargetFrameButton