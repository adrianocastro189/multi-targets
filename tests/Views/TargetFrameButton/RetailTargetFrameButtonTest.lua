TestRetailTargetFrameButton = BaseTestClass:new()
    -- @covers RetailTargetFrameButton.__construct()
    function TestRetailTargetFrameButton:testConstructor()
        local targetFrameButton = MultiTargets.__:new('MultiTargetsRetailTargetFrameButton')
        targetFrameButton:initialize()

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals('adding', targetFrameButton.state)
    end
-- end of TestRetailTargetFrameButton