--[[--
Class description.
]]
local TargetWindow = {}
    TargetWindow.__index = TargetWindow
    -- TargetWindow inherits from Window
    setmetatable(TargetWindow, MultiTargets.__:getClass('Window'))

    --[[--
    TargetWindow constructor.
    ]]
    function TargetWindow.__construct()
        local self = setmetatable({}, TargetWindow)

        self.id = 'targets-window'

        self:setFirstSize({width = 250, height = 400})
        self:setTitle('MultiTargets')

        return self
    end
-- end of TargetWindow

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetWindow', TargetWindow)