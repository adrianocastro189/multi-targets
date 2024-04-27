TestMultiTargets = BaseTestClass:new()
    -- @covers MultiTargets
    function TestMultiTargets:testAddonData()
        lu.assertNotIsNil(MultiTargets)
        lu.assertNotIsNil(MultiTargets_Data)
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.targets'), {})
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.current'), 0)
        lu.assertNotIsNil(MultiTargets.markerRepository)
        lu.assertNotIsNil(MultiTargets.targetFrameButton)
        lu.assertNotIsNil(MultiTargets.targetWindow)
    end

    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
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
    end

    -- @covers MultiTargets:loadTargetList()
    function TestMultiTargets:testLoadTargetList()
        MultiTargets:loadTargetList('test-loaded-target-list')

        lu.assertNotNil(MultiTargets.currentTargetList)
        lu.assertEquals(MultiTargets.currentTargetList.listName, 'test-loaded-target-list')
    end

    -- @covers MultiTargets:out()
    function TestMultiTargets:testOut()
        MultiTargets:out('test message')

        lu.assertTrue(MultiTargets.__.output:printed('test message'))
    end
-- end of MultiTargetsTest