--[[
The Macro class in the MultiTargets addon is an extension of the Macro model
from the Stormwind Library and is used to represent the macro created to
rotate through multiple targets.
]]
local Macro = {}
    Macro.__index = Macro
    MultiTargets:addChildClass('MultiTargets/Macro', Macro, 'Macro')

    --[[
    Macro constructor.
    ]]
    function Macro.__construct()
        local self = setmetatable({}, Macro)

        self.name = 'MultiTargetsMacro'
        self:setIcon('ability_hunter_focusedaim')

        return self
    end

    --[[
    Updates the macro body and saves it.
    ]]
    function Macro:updateMacro(body)
        self:setBody(body)
        self:save()
    end
-- end of Macro