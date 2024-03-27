TestTargetFrameButton = {}
    -- @covers TargetFrameButton.__construct()
    -- @covers TargetFrameButton:createButton()
    function TestTargetFrameButton:testConstructor()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals(targetFrameButton.state, 'adding')
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
-- end of TestTargetFrameButton