--[[
The Macro class in the MultiTargets addon is an extension of the Macro model
from the Stormwind Library and is used to represent the macro created to
rotate through multiple targets.
]]
local Macro = {}
    Macro.__index = Macro
    setmetatable(Macro, MultiTargets.__:getClass('Macro'))

    --[[
    Macro constructor.
    ]]
    function Macro.__construct()
        local self = setmetatable({}, Macro)

        -- add properties here

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

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsMacro', Macro)