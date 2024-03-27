TestTargetFrameButton = {}
    -- @covers TargetFrameButton.__construct()
    -- @covers TargetFrameButton:createButton()
    function TestTargetFrameButton:testConstructor()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals(targetFrameButton.state, 'adding')
    end

    -- @covers TargetFrameButton:onButtonClick()
    function TestTargetFrameButton:testOnButtonClick()
        local function execution(buttonState, expectedMethod)
            local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')
            targetFrameButton.state = buttonState

            local originalMethod = MultiTargets[expectedMethod]

            local methodInvoked = false
            MultiTargets[expectedMethod] = function()
                methodInvoked = true
            end

            lu.assertIsFalse(methodInvoked)

            targetFrameButton:onButtonClick()
            
            lu.assertIsTrue(methodInvoked)

            MultiTargets[expectedMethod] = originalMethod
        end

        execution('adding', 'addTargetted')
        execution('removing', 'removeTargetted')
    end

    -- @covers TargetFrameButton:isAdding()
    -- @covers TargetFrameButton:isRemoving()
    function TestTargetFrameButton:testStateCheckers()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

        lu.assertTrue(targetFrameButton:isAdding())
        lu.assertFalse(targetFrameButton:isRemoving())

        targetFrameButton.state = 'removing'

        lu.assertFalse(targetFrameButton:isAdding())
        lu.assertTrue(targetFrameButton:isRemoving())
    end

    -- @covers TargetFrameButton:turnAddState()
    -- @covers TargetFrameButton:turnRemoveState()
    function TestTargetFrameButton:testTurnMethods()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

        targetFrameButton:turnRemoveState()

        lu.assertFalse(targetFrameButton:isAdding())
        lu.assertTrue(targetFrameButton:isRemoving())

        targetFrameButton:turnAddState()

        lu.assertTrue(targetFrameButton:isAdding())
        lu.assertFalse(targetFrameButton:isRemoving())
    end

    -- @covers TargetFrameButton:updateState()
    function TestTargetFrameButton:testUpdateState()
        local function execution(currentTargetName, currentTargetListHasTargetName, expectedMethod)
            local originalTarget = MultiTargets.__.target
            local originalCurrentList = MultiTargets.currentTargetList

            local targetListMock = MultiTargets.__:new('MultiTargetsTargetList', 'test')
            targetListMock.has = function() return currentTargetListHasTargetName end
            MultiTargets.currentTargetList = targetListMock

            local targetMock = MultiTargets.__:new('Target')
            targetMock.getName = function() return currentTargetName end
            MultiTargets.__.target = targetMock

            local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')
            local methodInvoked = nil
            targetFrameButton.turnAddState = function() methodInvoked = 'turnAddState' end
            targetFrameButton.turnRemoveState = function() methodInvoked = 'turnRemoveState' end

            targetFrameButton:updateState()

            lu.assertEquals(methodInvoked, expectedMethod)

            MultiTargets.__.target = originalTarget
            MultiTargets.currentTargetList = originalCurrentList
        end

        execution(nil, false, nil)
        execution('test', false, 'turnAddState')
        execution('test', true, 'turnRemoveState')
    end
-- end of TestTargetFrameButton