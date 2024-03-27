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
-- end of TestTargetFrameButton