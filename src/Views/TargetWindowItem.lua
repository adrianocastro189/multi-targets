--[[
The target window item is a visual representation of a target in a target
list that composes the target window.

It's created to show target instance information and should contain all the
controls to support user interaction with the target like the target name, a
button to remove it from the list, its raid marker, among others.

Although created to represent a target, its setTarget() method must be
called for the frame to reflect the target instance information.
]]
local TargetWindowItem = {}
    TargetWindowItem.__index = TargetWindowItem

    --[[
    TargetWindowItem constructor.
    ]]
    function TargetWindowItem.__construct()
        local self = setmetatable({}, TargetWindowItem)

        return self
    end

    --[[
    Triggers the target window item frame creation and its controls.

    This method is the only one to be called by the addon. The other create
    methods are internal and should not be called directly.

    @treturn TargetWindowItem The instance to allow method chaining
    ]]
    function TargetWindowItem:create()
        self:createFrame()

        return self
    end

    --[[
    Creates the target window item frame using the World of Warcraft API.

    @local

    @return The frame component created
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
        frame:Hide()

        self.frame = frame

        self:createRaidMarker()
        self:createLabel()
        self:createRemoveButton()

        return frame
    end

    --[[
    Creates the target window item label using the World of Warcraft API.

    The frame label will contain the target name.

    @local

    @return The label component created
    ]]
    function TargetWindowItem:createLabel()
        local label = self.frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        label:SetFont('Fonts\\ARIALN.ttf', 14)
        label:SetPoint('LEFT', self.raidMarker, 'LEFT', 20, 0)
        label:SetText('')

        self.label = label

        return label
    end

    --[[
    Creates the target window item raid marker using the World of Warcraft
    API.

    The frame raid marker will contain the target raid marker obtained from
    the target instance.

    @local

    @return The raid marker component created
    ]]
    function TargetWindowItem:createRaidMarker()
        local raidMarker = self.frame:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        raidMarker:SetFont('Fonts\\ARIALN.ttf', 14)
        raidMarker:SetPoint('LEFT', self.frame, 'LEFT', 10, 0)
        raidMarker:SetText('')

        self.raidMarker = raidMarker

        return raidMarker
    end

    --[[
    Creates the target window item remove button using the World of Warcraft
    API.

    @local

    @return The remove button component created
    ]]
    function TargetWindowItem:createRemoveButton()
        local button = CreateFrame('Button', nil, self.frame, 'UIPanelButtonTemplate')
        button:SetPoint('RIGHT', self.frame, 'RIGHT', -5, 0)
        button:SetScript('OnClick', function() self:onRemoveClick() end)
        button:SetText('Remove')
        button:SetWidth(60)

        self.removeButton = button

        return button
    end

    --[[
    Handles the remove button click event.
    ]]
    function TargetWindowItem:onRemoveClick()
        MultiTargets:invokeOnCurrent('remove', self.target.name)
    end

    --[[
    Sets the target instance to be represented by this target window item.

    This method also updates the frame controls to reflect the target
    instance information and sets the frame to be visible.

    When called with a nil target, the frame will be hidden.

    @tparam Target target The target instance to be represented by this component
    ]]
    function TargetWindowItem:setTarget(target)
        self.label:SetText(target and target.name or '')
        self.raidMarker:SetText(target and target.raidMarker:getPrintableString() or '')
        self.target = target

        self.frame[target and 'Show' or 'Hide'](self.frame)

        return self
    end
-- end of TargetWindowItem

-- allows this class to be instantiated
MultiTargets.__:addClass('MultiTargetsTargetWindowItem', TargetWindowItem)