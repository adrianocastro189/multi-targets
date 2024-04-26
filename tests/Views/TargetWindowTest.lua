TestTargetWindow = BaseTestClass:new()
    -- @covers TargetWindow:__construct()
    function TestTargetWindow:testConstruct()
        local instance = MultiTargets.__:new('MultiTargetsTargetWindow')

        lu.assertNotNil(instance)
        lu.assertEquals(instance.id, 'targets-window')
        -- confirm that the instance is a subclass of Window
        lu.assertIsFunction(instance.create)

        lu.assertEquals(instance.firstSize.width, 250)
        lu.assertEquals(instance.firstSize.height, 400)
    end
-- end of TestClassName