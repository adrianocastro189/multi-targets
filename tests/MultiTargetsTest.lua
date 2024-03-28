TestMultiTargets = {}
    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
        local originalTargetList = MultiTargets.currentTargetList

        MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')

        MultiTargets:invokeOnCurrent('add', 'test-target-1')

        lu.assertEquals(MultiTargets.currentTargetList.targets, {target})

        MultiTargets:invokeOnCurrent('remove', 'test-target-1')

        lu.assertEquals(MultiTargets.currentTargetList.targets, {})

        -- emulates the target list not being loaded
        MultiTargets.currentTargetList = nil

        -- should not throw an error
        MultiTargets:invokeOnCurrent('add', 'test-target-1')

        MultiTargets.currentTargetList = originalTargetList
    end
-- end of MultiTargetsTest