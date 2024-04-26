TestTargetWindowItem = BaseTestClass:new()
    -- @covers TargetWindowItem:__construct()
    function TestTargetWindowItem:testConstruct()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-target')

        local instance = MultiTargets.__:new('MultiTargetsTargetWindowItem', target)

        lu.assertNotNil(instance)
        lu.assertEquals(instance.target, target)
    end
-- end of TestTargetWindowItem