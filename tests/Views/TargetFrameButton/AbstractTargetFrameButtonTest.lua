TestAbstractTargetFrameButton = BaseTestClass:new()
    -- helper method to instantiate the abstract class
    function TestAbstractTargetFrameButton:instance()
        -- instantiating an abstract class here is ok for the sake of testing
        return MultiTargets:getClass('MultiTargets/AbstractTargetFrameButton').__construct()
    end

    -- @covers AbstractTargetFrameButton.__construct()
    -- @covers AbstractTargetFrameButton:createButton()
    -- @covers AbstractTargetFrameButton:initialize()
    function TestAbstractTargetFrameButton:testConstructor()
        local targetFrameButton = self:instance()
        targetFrameButton.getOffset = function() return 0, 0 end
        targetFrameButton:initialize()

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals('adding', targetFrameButton.state)
    end

    -- @covers AbstractTargetFrameButton:getOffset()
    function TestAbstractTargetFrameButton:testGetOffset()
        local targetFrameButton = self:instance()

        lu.assertErrorMsgContentEquals('This is an abstract method and should be implemented by this class inheritances', function()
            targetFrameButton:getOffset()
        end)
    end

    -- @covers AbstractTargetFrameButton:onButtonClick()
    function TestAbstractTargetFrameButton:testOnButtonClick()
        local function execution(buttonState, expectedMethod)
            local targetFrameButton = self:instance()
            targetFrameButton.state = buttonState

            local updateStateInvoked = false
            targetFrameButton.updateState = function() updateStateInvoked = true end

            local invokeOnCurrentArg = nil
            function MultiTargets:invokeOnCurrent(method)
                invokeOnCurrentArg = method
            end

            lu.assertIsNil(invokeOnCurrentArg)

            targetFrameButton:onButtonClick()
            
            lu.assertEquals(expectedMethod, invokeOnCurrentArg)
            lu.assertIsTrue(updateStateInvoked)
        end

        execution('adding', 'addTargetted')
        execution('removing', 'removeTargetted')
    end

    -- @covers AbstractTargetFrameButton:observeRelevantEvents()
    function TestAbstractTargetFrameButton:testObserveRelevantEvents()
        local function execution(event, shouldInvoke)
            MultiTargets.events.listeners = {}

            local targetFrameButton = self:instance()
            targetFrameButton.getOffset = function() return 0, 0 end
            targetFrameButton:initialize()

            local methodInvoked = false
            targetFrameButton.updateState = function()
                methodInvoked = true
            end

            lu.assertIsFalse(methodInvoked)

            MultiTargets.events:notify(event)

            lu.assertEquals(shouldInvoke, methodInvoked)
        end

        -- events that should invoke the updateState method
        execution('PLAYER_ENTERED_COMBAT', true)
        execution('PLAYER_LEFT_COMBAT', true)
        execution('TARGET_LIST_REFRESHED', true)
        execution('PLAYER_TARGET', true)
        execution('PLAYER_TARGET_CHANGED', true)

        -- events that should not invoke the updateState method
        -- just one example here to make sure the method is not invoked
        execution('PLAYER_TARGET_CLEAR', false)
    end

    -- @covers AbstractTargetFrameButton:isAdding()
    -- @covers AbstractTargetFrameButton:isRemoving()
    function TestAbstractTargetFrameButton:testStateCheckers()
        local targetFrameButton = self:instance()
        targetFrameButton.getOffset = function() return 0, 0 end
        targetFrameButton:initialize()

        lu.assertTrue(targetFrameButton:isAdding())
        lu.assertFalse(targetFrameButton:isRemoving())

        targetFrameButton.state = 'removing'

        lu.assertFalse(targetFrameButton:isAdding())
        lu.assertTrue(targetFrameButton:isRemoving())
    end

    -- @covers AbstractTargetFrameButton:turnAddState()
    -- @covers AbstractTargetFrameButton:turnRemoveState()
    function TestAbstractTargetFrameButton:testTurnMethods()
        local targetFrameButton = self:instance()
        targetFrameButton.getOffset = function() return 0, 0 end
        targetFrameButton:initialize()

        targetFrameButton:turnRemoveState()

        lu.assertFalse(targetFrameButton:isAdding())
        lu.assertTrue(targetFrameButton:isRemoving())

        targetFrameButton:turnAddState()

        lu.assertTrue(targetFrameButton:isAdding())
        lu.assertFalse(targetFrameButton:isRemoving())
    end

    -- @covers AbstractTargetFrameButton:updateState()
    function TestAbstractTargetFrameButton:testUpdateState()
        local function execution(currentTargetName, currentTargetListHasTargetName, expectedMethod)
            local targetListMock = MultiTargets:new('MultiTargets/TargetList', 'test')
            targetListMock.has = function() return currentTargetListHasTargetName end
            MultiTargets.currentTargetList = targetListMock

            local targetMock = MultiTargets:new('Target')
            targetMock.getName = function() return currentTargetName end
            MultiTargets.target = targetMock

            local targetFrameButton = self:instance()
            targetFrameButton.updateVisibility = function() targetFrameButton.updateVisibilityInvoked = true end
            targetFrameButton.getOffset = function() return 0, 0 end
            targetFrameButton:initialize()

            local methodInvoked = nil
            targetFrameButton.turnAddState = function() methodInvoked = 'turnAddState' end
            targetFrameButton.turnRemoveState = function() methodInvoked = 'turnRemoveState' end

            targetFrameButton:updateState()

            lu.assertEquals(expectedMethod, methodInvoked)
            lu.assertIsTrue(targetFrameButton.updateVisibilityInvoked)
        end

        execution(nil, false, nil)
        execution('test', false, 'turnAddState')
        execution('test', true, 'turnRemoveState')
    end

    -- @covers AbstractTargetFrameButton:updateVisibility()
    function TestAbstractTargetFrameButton:testUpdateVisibility()
        local function execution(playerInCombat, shouldShow, shouldHide)
            MultiTargets.currentPlayer.inCombat = playerInCombat

            local targetFrameButton = self:instance()
            targetFrameButton.buttonShowInvoked = false
            targetFrameButton.buttonHideInvoked = false

            targetFrameButton.button = {
                Show = function() targetFrameButton.buttonShowInvoked = true end,
                Hide = function() targetFrameButton.buttonHideInvoked = true end,
            }

            targetFrameButton:updateVisibility()

            lu.assertEquals(shouldShow, targetFrameButton.buttonShowInvoked)
            lu.assertEquals(shouldHide, targetFrameButton.buttonHideInvoked)
        end

        -- player in combat
        execution(true, false, true)

        -- player not in combat
        execution(false, true, false)
    end
-- end of TestAbstractTargetFrameButton