TestTargetFrameButton = {}
    -- @covers TargetFrameButton.__construct()
    -- @covers TargetFrameButton:createButton()
    function TestTargetFrameButton:testConstructor()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
    end
-- end of TestTargetFrameButton