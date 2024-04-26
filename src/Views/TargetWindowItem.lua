--[[
The target window item is a visual representation of a target in a target
list that composes the target window.

It's created from a Target instance and should contain all the controls to
support user interaction with the target like the target name, a button to
remove it from the list, its raid marker, among others.
]]
local TargetWindowItem = {}
    TargetWindowItem.__index = TargetWindowItem

    --[[--
    TargetWindowItem constructor.

    @param Target target The target instance to be represented by this component
    ]]
    function TargetWindowItem.__construct(target)
        local self = setmetatable({}, TargetWindowItem)

        self.target = target

        return self
    end

    --[[
    Creates the target window item frame and its controls.

    @return TargetWindowItem The instance to allow method chaining
    ]]
    function TargetWindowItem:create()
        self:createFrame()

        return self
    end

    --[[
    Creates the target window item frame using the World of Warcraft API.

    @local

    @return Frame The frame created
    ]]
    function TargetWindowItem:createFrame()
        -- the parent frame is nil for now, but must be set to the target
        -- window later when it should be visible
        local frame = CreateFrame('Frame', nil, nil, 'BackdropTemplate')

        frame:SetBackdrop({
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = '',
            edgeSize = 4,
            insets = {left = 5, right = 1, top = 1, bottom = 1},
        })
        frame:SetBackdropColor(0, 0, 0, .2)
        frame:SetHeight(30)

        self.frame = frame

        self:createRaidMarker()
        self:createLabel()
        self:createRemoveButton()

        return frame
    end
-- end of TargetWindowItem

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetWindowItem', TargetWindowItem)