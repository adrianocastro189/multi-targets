TestClassicTargetFrameButton = BaseTestClass:new()
    -- @covers ClassicTargetFrameButton.__construct()
    function TestClassicTargetFrameButton:testConstructor()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsClassicTargetFrameButton')
        targetFrameButton:initialize()

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals('adding', targetFrameButton.state)
    end
-- end of TestClassicTargetFrameButton