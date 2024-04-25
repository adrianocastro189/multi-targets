TestMultiTargets = BaseTestClass:new()
    -- @covers MultiTargets
    function TestMultiTargets:testAddonData()
        lu.assertNotIsNil(MultiTargets)
        lu.assertNotIsNil(MultiTargets_Data)
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.targets'), {})
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.current'), 0)
        lu.assertNotIsNil(MultiTargets.markerRepository)
    end

    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
        local originalTargetList = MultiTargets.currentTargetList

        MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        MultiTargets.currentTargetList.updateMacroWithCurrentTarget = function () end

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

    -- @covers MultiTargets:loadTargetList()
    function TestMultiTargets:testLoadTargetList()
        local originalTargetList = MultiTargets.currentTargetList

        MultiTargets:loadTargetList('test-loaded-target-list')

        lu.assertNotNil(MultiTargets.currentTargetList)
        lu.assertEquals(MultiTargets.currentTargetList.listName, 'test-loaded-target-list')

        MultiTargets.currentTargetList = originalTargetList
    end

    -- @covers MultiTargets:out()
    function TestMultiTargets:testOut()
        MultiTargets:out('test message')

        lu.assertTrue(MultiTargets.__.output:printed('test message'))
    end
-- end of MultiTargetsTest