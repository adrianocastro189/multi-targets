TestTargetWindowItem = BaseTestClass:new()
    -- @covers TargetWindowItem:__construct()
    function TestTargetWindowItem:testConstruct()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        lu.assertNotNil(instance)
    end

    -- @covers TargetWindowItem:create()
    function TestTargetWindowItem:testCreate()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.createFrame = function() instance.createFrameInvoked = true end

        local result = instance:create()

        lu.assertIsTrue(instance.createFrameInvoked)
        lu.assertEquals(instance, result)
    end

    -- @covers TargetWindowItem:createFrame()
    function TestTargetWindowItem:testCreateFrame()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.createPointer = function() instance.createPointerInvoked = true end
        instance.createRaidMarker = function() instance.createRaidMarkerInvoked = true end
        instance.createLabel = function() instance.createLabelInvoked = true end
        instance.createRemoveButton = function() instance.createRemoveButtonInvoked = true end

        local result = instance:createFrame()

        lu.assertEquals(instance.frame, result)

        lu.assertEquals({
            bgFile = 'Interface/Tooltips/UI-Tooltip-Background',
            edgeFile = '',
            edgeSize = 4,
            insets = {left = 5, right = 1, top = 1, bottom = 1},
        }, result.backdrop)
        lu.assertEquals({0, 0, 0, .2}, result.backdropColor)
        lu.assertEquals(30, result.height)
        lu.assertIsTrue(result.hideInvoked)

        lu.assertIsTrue(instance.createPointerInvoked)
        lu.assertIsTrue(instance.createRaidMarkerInvoked)
        lu.assertIsTrue(instance.createLabelInvoked)
        lu.assertIsTrue(instance.createRemoveButtonInvoked)
    end

    -- @covers TargetWindowItem:createLabel()
    function TestTargetWindowItem:testCreateLabel()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.frame = CreateFrame()

        local result = instance:createLabel()

        lu.assertEquals(instance.label, result)
        lu.assertEquals('Fonts\\ARIALN.ttf', result.fontFamily)
        lu.assertEquals(14, result.fontSize)
        lu.assertEquals('', result.text)
        lu.assertEquals({
            LEFT = {
                relativeFrame = instance.raidMarker,
                relativePoint = 'LEFT',
                xOfs = 20,
                yOfs = 0,
            },
        }, result.points)
    end

    -- @covers TargetWindowItem:createRaidMarker()
    function TestTargetWindowItem:testCreateRaidMarker()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.frame = CreateFrame()

        local result = instance:createRaidMarker()

        lu.assertEquals(instance.raidMarker, result)
        lu.assertEquals('Fonts\\ARIALN.ttf', result.fontFamily)
        lu.assertEquals(14, result.fontSize)
        lu.assertEquals({
            LEFT = {
                relativeFrame = instance.pointer,
                relativePoint = 'LEFT',
                xOfs = 20,
                yOfs = 0,
            },
        }, result.points)
        lu.assertEquals('', result.text)
    end

    -- @covers TargetWindowItem:createPointer()
    function TestTargetWindowItem:testCreatePointer()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.frame = CreateFrame()

        local result = instance:createPointer()

        lu.assertEquals(instance.pointer, result)
        lu.assertEquals('Interface\\AddOns\\MultiTargets\\resources\\img\\icons\\caret.png', result.texture)
        lu.assertEquals(16, result.width)
        lu.assertEquals(16, result.height)
        lu.assertEquals({
            LEFT = {
                relativeFrame = instance.frame,
                relativePoint = 'LEFT',
                xOfs = 10,
                yOfs = 0,
            },
        }, result.points)
    end

    -- @covers TargetWindowItem:createRemoveButton()
    function TestTargetWindowItem:testCreateRemoveButton()
        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')

        instance.frame = CreateFrame()

        local result = instance:createRemoveButton()

        lu.assertEquals(instance.removeButton, result)
        lu.assertEquals({
            RIGHT = {
                relativeFrame = instance.frame,
                relativePoint = 'RIGHT',
                xOfs = -5,
                yOfs = 0,
            },
        }, result.points)
        lu.assertNotIsNil(result.scripts['OnClick'])
        lu.assertEquals('Remove', result.text)
        lu.assertEquals(60, result.width)
    end

    -- @covers TargetWindowItem:onRemoveClick()
    function TestTargetWindowItem:testOnRemoveClick()
        local target = MultiTargets:new('MultiTargets/Target', 'test-target')
        
        ---@diagnostic disable-next-line: duplicate-set-field
        function MultiTargets:invokeOnCurrent(operation, targetName)
            self.operationArg = operation
            self.targetNameArg = targetName
        end

        local instance = MultiTargets:new('MultiTargets/TargetWindowItem')
        instance.target = target

        instance:onRemoveClick()

        lu.assertEquals('remove', MultiTargets.operationArg)
        lu.assertEquals('test-target', MultiTargets.targetNameArg)
    end

    -- @covers TargetWindowItem:setPointerVisibility()
    function TestTargetWindowItem:testSetPointerVisibility()
        local function execution(isCurrent, shouldShow, shouldHide)
            local item = MultiTargets:new('MultiTargets/TargetWindowItem')
            item.pointer = {
                hideInvoked = false,
                showInvoked = false,
                Hide = function() item.pointer.hideInvoked = true end,
                Show = function() item.pointer.showInvoked = true end,
            }

            MultiTargets.invokeOnCurrent = function() return isCurrent end

            item:setPointerVisibility('test-target')

            lu.assertEquals(shouldShow, item.pointer.showInvoked)
            lu.assertEquals(shouldHide, item.pointer.hideInvoked)
        end
        
        -- is current, should show, should not hide
        execution(true, true, false)

        -- is not current, should not show, should hide
        execution(false, false, true)
    end

    -- @covers TargetWindowItem:setTarget()
    function TestTargetWindowItem:testSetTargetWithNilValue()
        local instance = MultiTargets
            :new('MultiTargets/TargetWindowItem')
            :create()

        instance:setTarget(nil)

        lu.assertIsNil(instance.target)
        lu.assertEquals('', instance.label.text)
        lu.assertEquals('', instance.raidMarker.text)
        lu.assertIsTrue(instance.frame.hideInvoked)
    end

    -- @covers TargetWindowItem:setTarget()
    function TestTargetWindowItem:testSetTargetWithValidTarget()
        local instance = MultiTargets
            :new('MultiTargets/TargetWindowItem')
            :create()

        local target = MultiTargets:new('MultiTargets/Target', 'test-target')

        instance.setPointerVisibility = function() instance.setPointerVisibilityInvoked = true end

        instance:setTarget(target)

        lu.assertEquals(instance.target, target)
        lu.assertEquals('test-target', instance.label.text)
        lu.assertEquals(instance.raidMarker.text, target.raidMarker:getPrintableString())
        lu.assertIsTrue(instance.setPointerVisibilityInvoked)
    end
-- end of TestTargetWindowItem