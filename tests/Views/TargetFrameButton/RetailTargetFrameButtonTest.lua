TestRetailTargetFrameButton = BaseTestClass:new()
    -- helper method to instantiate the classic implementation
    function TestRetailTargetFrameButton:instance()
        MultiTargets.__.environment.getClientFlavor = function () return MultiTargets.__.environment.constants.CLIENT_RETAIL end
        return MultiTargets.__:new('MultiTargets/TargetFrameButton')
    end

    -- @covers RetailTargetFrameButton.__construct()
    function TestRetailTargetFrameButton:testConstructor()
        local targetFrameButton = self:instance()
        targetFrameButton:initialize()

        lu.assertNotNil(targetFrameButton)
        lu.assertNotNil(targetFrameButton.button)
        lu.assertEquals('adding', targetFrameButton.state)
    end
-- end of TestRetailTargetFrameButton