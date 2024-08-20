TestMultiTargets = BaseTestClass:new()

-- @covers MultiTargets
TestCase.new()
    :setName('addon table')
    :setTestClass(TestMultiTargets)
    :setExecution(function()
        lu.assertNotIsNil(MultiTargets)
        lu.assertNotIsNil(MultiTargets_Data)
        lu.assertEquals({}, MultiTargets.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.targets'))
        lu.assertEquals(0, MultiTargets.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.current'))
        lu.assertNotIsNil(MultiTargets.markerRepository)
        lu.assertNotIsNil(MultiTargets.minimapIcon)
        lu.assertNotIsNil(MultiTargets.targetFrameButton)
        lu.assertNotIsNil(MultiTargets.targetWindow)
    end)
    :register()

TestCase.new()
    :setName('invokeOnCurrent')
    :setTestClass(TestMultiTargets)
    :setExecution(function()
        MultiTargets.currentTargetList = Spy
            .new(MultiTargets:new('MultiTargets/TargetList', 'default'))
            :mockMethod('invoke')

        MultiTargets:invokeOnCurrent('method', 'arg1', 'arg2')

        MultiTargets
            .currentTargetList
            :getMethod('invoke')
            :assertCalledOnceWith('method', 'arg1', 'arg2')
    end)
    :register()

TestCase.new()
    :setName('invokeOnCurrent with no target list')
    :setTestClass(TestMultiTargets)
    :setExecution(function()
        MultiTargets.currentTargetList = nil

        -- just asserts no error is thrown
        MultiTargets:invokeOnCurrent('method', 'arg1', 'arg2')
    end)
    :register()

TestCase.new()
    :setName('loadTargetList')
    :setTestClass(TestMultiTargets)
    :setExecution(function()
        MultiTargets:loadTargetList('test-loaded-target-list')

        lu.assertNotNil(MultiTargets.currentTargetList)
        lu.assertEquals('test-loaded-target-list', MultiTargets.currentTargetList.listName)
    end)
    :register()

TestCase.new()
    :setName('out')
    :setTestClass(TestMultiTargets)
    :setExecution(function()
        MultiTargets:out('test message')

        lu.assertTrue(MultiTargets.output:printed('test message'))
    end)
    :register()
-- end of MultiTargetsTest