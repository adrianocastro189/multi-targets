TestMultiTargets = BaseTestClass:new()
    -- @covers MultiTargets
    function TestMultiTargets:testAddonData()
        lu.assertNotIsNil(MultiTargets)
        lu.assertNotIsNil(MultiTargets_Data)
        lu.assertEquals({}, MultiTargets.__.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.targets'))
        lu.assertEquals(0, MultiTargets.__.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.current'))
        lu.assertNotIsNil(MultiTargets.markerRepository)
        lu.assertNotIsNil(MultiTargets.targetFrameButton)
        lu.assertNotIsNil(MultiTargets.targetWindow)
    end

    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
        MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargets/TargetList', 'default')
        MultiTargets.currentTargetList.updateMacroWithCurrentTarget = function () end

        local target = MultiTargets.__:new('MultiTargets/Target', 'test-target-1')

        MultiTargets:invokeOnCurrent('add', 'test-target-1')

        lu.assertEquals({target}, MultiTargets.currentTargetList.targets)

        MultiTargets:invokeOnCurrent('remove', 'test-target-1')

        lu.assertEquals({}, MultiTargets.currentTargetList.targets)

        -- emulates the target list not being loaded
        MultiTargets.currentTargetList = nil

        -- should not throw an error
        MultiTargets:invokeOnCurrent('add', 'test-target-1')
    end

    -- @covers MultiTargets:loadTargetList()
    function TestMultiTargets:testLoadTargetList()
        MultiTargets:loadTargetList('test-loaded-target-list')

        lu.assertNotNil(MultiTargets.currentTargetList)
        lu.assertEquals('test-loaded-target-list', MultiTargets.currentTargetList.listName)
    end

    -- @covers MultiTargets:out()
    function TestMultiTargets:testOut()
        MultiTargets:out('test message')

        lu.assertTrue(MultiTargets.__.output:printed('test message'))
    end
-- end of MultiTargetsTest