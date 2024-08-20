TestMultiTargets = BaseTestClass:new()
    -- @covers MultiTargets
    function TestMultiTargets:testAddonData()
        lu.assertNotIsNil(MultiTargets)
        lu.assertNotIsNil(MultiTargets_Data)
        lu.assertEquals({}, MultiTargets.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.targets'))
        lu.assertEquals(0, MultiTargets.arr:get(MultiTargets_Data, 'test-realm.test-player-name.lists.default.current'))
        lu.assertNotIsNil(MultiTargets.markerRepository)
        lu.assertNotIsNil(MultiTargets.targetFrameButton)
        lu.assertNotIsNil(MultiTargets.targetWindow)
    end

    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
        MultiTargets.currentTargetList = MultiTargets:new('MultiTargets/TargetList', 'default')
        MultiTargets.currentTargetList.invoke = function (instance, methodName, arg1, arg2)
            MultiTargets.currentTargetList.methodNameArg = methodName
            MultiTargets.currentTargetList.arg1 = arg1
            MultiTargets.currentTargetList.arg2 = arg2
        end

        MultiTargets:invokeOnCurrent('test-target-list-method', 'test-arg-1', 'test-arg-2')

        lu.assertEquals('test-target-list-method', MultiTargets.currentTargetList.methodNameArg)
        lu.assertEquals('test-arg-1', MultiTargets.currentTargetList.arg1)
        lu.assertEquals('test-arg-2', MultiTargets.currentTargetList.arg2)

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

        lu.assertTrue(MultiTargets.output:printed('test message'))
    end
-- end of MultiTargetsTest