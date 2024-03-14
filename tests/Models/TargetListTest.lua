TestTargetList = {}
    -- executes before each tests
    function TestTargetList:setUp()
        -- resets the addon data
        MultiTargets_Data = {}
    end

    -- @covers TargetList:currentIsValid()
    function TestTargetList:testCanDetermineCurrentIsValid()
        local execution = function (targets, current, expectedResult)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

            targetList.targets = targets
            targetList.current = current
        
            lu.assertEquals(targetList:currentIsValid(), expectedResult)
        end

        execution({}, 0, false)
        execution({'t-1'}, 0, false)
        execution({'t-1'}, 1, true)
        execution({'t-1'}, 2, false)
        execution({'t-1', 't-2'}, 2, true)
        execution({'t-1', 't-2'}, 3, false)
    end

    -- @covers TargetList:isEmpty()
    function TestTargetList:testCanDetermineIsEmpty()
        local execution = function (targets, expectedResult)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
            targetList.targets = targets
        
            lu.assertEquals(targetList:isEmpty(), expectedResult)
        end

        execution({}, true)
        execution({'t-1'}, false)
    end

    -- @covers TargetList.__construct()
    function TestTargetList:testCanInstantiateTargetList()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertNotIsNil(targetList)
        lu.assertEquals(targetList.listName, 'default')
        lu.assertEquals(targetList.targets, {})
    end

    -- @covers TargetList:load()
    function TestTargetList:testCanLoad()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.loadTargets = function () targetList.invokedLoadTargets = true end
        targetList.loadCurrentIndex = function () targetList.invokedLoadCurrentIndex = true end
        targetList.sanitizeCurrent = function () targetList.invokedSanitizeCurrent = true end
        targetList.updateMacroWithCurrentTarget = function () targetList.invokedUpdateMacroWithCurrentTarget = true end

        lu.assertIsNil(targetList.invokedLoadTargets)
        lu.assertIsNil(targetList.invokedLoadCurrentIndex)
        lu.assertIsNil(targetList.invokedSanitizeCurrent)
        lu.assertIsNil(targetList.invokedUpdateMacroWithCurrentTarget)

        targetList:load()

        lu.assertIsTrue(targetList.invokedLoadTargets)
        lu.assertIsTrue(targetList.invokedLoadCurrentIndex)
        lu.assertIsTrue(targetList.invokedSanitizeCurrent)
        lu.assertIsTrue(targetList.invokedUpdateMacroWithCurrentTarget)
    end

    -- @covers TargetList:loadCurrentIndex()
    function TestTargetList:testCanLoadCurrentIndex()
        MultiTargets.__.arr:set(MultiTargets_Data, 'lists.default.current', 2)

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertEquals(targetList.current, 0)

        targetList:loadCurrentIndex()

        lu.assertEquals(targetList.current, 2)
    end

    -- @covers TargetList:loadTargets()
    function TestTargetList:testCanLoadTargets()
        MultiTargets.__.arr:set(MultiTargets_Data, 'lists.default.targets', {
            'test-target-1',
            'test-target-2',
            'test-target-3',
        })

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertEquals(#targetList.targets, 0)

        targetList:loadTargets()

        local targets = targetList.targets

        lu.assertEquals(targets, {
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-1'),
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-2'),
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-3'),
        })
    end

    -- @covers TargetList:rotate()
    function TestTargetList:testCanRotate()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.sanitizeCurrent = function () end
        targetList.updateMacroWithCurrentTarget = function () end
        targetList.save = function () end

        targetList.current = 5

        targetList:rotate()

        lu.assertEquals(targetList.current, 6)
    end

    -- @covers TargetList:sanitizeCurrent()
    function TestTargetList:testCanSanitizeCurrent()
        local function execution(isEmpty, currentIsValid, current, expectedCurrent)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
            targetList.isEmpty = function () return isEmpty end
            targetList.currentIsValid = function () return currentIsValid end
            targetList.current = current
        
            targetList:sanitizeCurrent()
        
            lu.assertEquals(targetList.current, expectedCurrent)
        end

        -- isEmpty, so current must be zero
        execution(true, true, 1, 0)

        -- current is valid, so current must be not changed
        execution(false, true, 1, 1)

        -- is not empty and current is not valid, so it resets
        execution(false, false, 2, 1)
    end

    -- @covers TargetList:save()
    function TestTargetList:testCanSave()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

        targetList.targets = {targetA, targetB}
        targetList.current = 2

        targetList:save()

        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.targetsDataKey), {'test-target-a', 'test-target-b'})
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.currentDataKey), 2)
    end

    --[[
    @covers TargetList:updateMacroWithCurrentTarget()
    ]]
    function TestTargetList:testCanUpdateMacroWithCurrentTarget()
        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')

        targetA.updateMacro = function () targetA.invoked = true end
        targetB.updateMacro = function () targetB.invoked = true end

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.targets = {targetA, targetB}

        targetList:updateMacroWithCurrentTarget()

        lu.assertIsNil(targetA.invoked)
        lu.assertIsNil(targetB.invoked)

        targetList.current = 1

        targetList:updateMacroWithCurrentTarget()

        lu.assertIsTrue(targetA.invoked)
        lu.assertIsNil(targetB.invoked)

        targetList.current = 2

        targetList:updateMacroWithCurrentTarget()

        lu.assertIsTrue(targetB.invoked)
    end
-- end of TestTargetList