TestTargetWindow = BaseTestClass:new()
    -- @covers TargetWindow:__construct()
    function TestTargetWindow:testConstruct()
        local instance = MultiTargets.__:new('MultiTargetsTargetWindow')

        lu.assertNotNil(instance)
        lu.assertEquals(instance.id, 'targets-window')
        -- confirm that the instance is a subclass of Window
        lu.assertIsFunction(instance.create)

        lu.assertEquals(instance.firstPosition, {
            point = 'CENTER',
            relativePoint = 'CENTER',
            xOfs = 0,
            yOfs = 0
        })
        lu.assertEquals(instance.firstSize.width, 250)
        lu.assertEquals(instance.firstSize.height, 400)
        lu.assertIsTrue(instance.firstVisibility)
        lu.assertEquals(instance.title, 'MultiTargets')
    end

    -- @covers TargetWindow:handleTargetListRefreshEvent()
    function TestTargetWindow:testHandleTargetListRefreshEvent()
        -- @TODO: Implement this method <2024.04.26>
    end
-- end of TestClassName