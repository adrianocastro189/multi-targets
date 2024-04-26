TestTargetWindowItem = BaseTestClass:new()
    -- @covers TargetWindowItem:__construct()
    function TestTargetWindowItem:testConstruct()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-target')

        local instance = MultiTargets.__:new('MultiTargetsTargetWindowItem', target)

        lu.assertNotNil(instance)
        lu.assertEquals(instance.target, target)
    end

    -- @covers TargetWindowItem:create()
    function TestTargetWindowItem:testCreate()
        local instance = MultiTargets.__:new('MultiTargetsTargetWindowItem')

        instance.createFrame = function() instance.createFrameInvoked = true end

        local result = instance:create()

        lu.assertIsTrue(instance.createFrameInvoked)
        lu.assertEquals(result, instance)
    end
-- end of TestTargetWindowItem