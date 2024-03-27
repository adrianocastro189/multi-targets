TestTargetList = {}
    -- executes before each tests
    function TestTargetList:setUp()
        -- resets the addon data
        MultiTargets_Data = {}
    end

    -- @covers TargetList:add()
    function TestTargetList:testAdd()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.sanitizeCurrent = function () targetList.sanitizeCurrentInvoked = true end
        targetList.sanitizeMarks = function () targetList.sanitizeMarksInvoked = true end
        targetList.save = function () targetList.saveInvoked = true end

        -- tries two times to test if add() won't add duplicate names
        targetList:add('test-new-target')
        targetList:add('test-new-target')

        local expectedTargets = MultiTargets.__:new('MultiTargetsTarget', 'test-new-target')

        lu.assertEquals({expectedTargets}, targetList.targets)
        lu.assertIsTrue(targetList.sanitizeCurrentInvoked)
        lu.assertIsTrue(targetList.sanitizeMarksInvoked)
        lu.assertIsTrue(targetList.saveInvoked)
    end

    -- @covers TargetList:addTargetted()
    function TestTargetList:testAddTargetted()
        local function execution(targettedName, shouldInvokeAdd)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
            targetList.addInvoked = false
            targetList.add = function () targetList.addInvoked = true end

            local currentTargetFacade = MultiTargets.__.target

            MultiTargets.__.target = {
                getName = function () return targettedName end
            }

            targetList:addTargetted()

            lu.assertEquals(shouldInvokeAdd, targetList.addInvoked)

            MultiTargets.__.target = currentTargetFacade
        end

        execution('test-target-1', true)
        execution(nil, false)
    end

    -- @covers TargetList:clear()
    function TestTargetList:testClear()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.save = function () targetList.saveInvoked = true end
        targetList.targets = {MultiTargets.__:new('MultiTargetsTarget', 'test-new-target')}
        targetList.current = 1

        lu.assertIsNil(targetList.saveInvoked)

        targetList:clear()

        lu.assertEquals(targetList.targets, {})
        lu.assertEquals(targetList.current, 0)
        lu.assertIsTrue(targetList.saveInvoked)
    end

    -- @covers TargetList:currentIsValid()
    function TestTargetList:testCurrentIsValid()
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

    -- @covers TargetList:has()
    function TestTargetList:testHas()
        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-2')
        local targetC = MultiTargets.__:new('MultiTargetsTarget', 'test-target-3')

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.targets = {targetA, targetB}

        lu.assertIsTrue(targetList:has('test-target-1'))
        lu.assertIsTrue(targetList:has(targetA))

        lu.assertIsFalse(targetList:has('test-target-3'))
        lu.assertIsFalse(targetList:has(targetC))
    end

    -- @covers TargetList.__construct()
    function TestTargetList:testInstantiation()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertNotIsNil(targetList)
        lu.assertEquals(targetList.listName, 'default')
        lu.assertEquals(targetList.targets, {})
    end

    -- @covers TargetList:isEmpty()
    function TestTargetList:testIsEmpty()
        local execution = function (targets, expectedResult)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
            targetList.targets = targets
        
            lu.assertEquals(targetList:isEmpty(), expectedResult)
        end

        execution({}, true)
        execution({'t-1'}, false)
    end

    -- @covers TargetList:load()
    function TestTargetList:testLoad()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.loadTargets = function () targetList.invokedLoadTargets = true end
        targetList.loadCurrentIndex = function () targetList.invokedLoadCurrentIndex = true end
        targetList.sanitizeCurrent = function () targetList.invokedSanitizeCurrent = true end
        targetList.sanitizeMarks = function () targetList.invokedsanitizeMarks = true end
        targetList.updateMacroWithCurrentTarget = function () targetList.invokedUpdateMacroWithCurrentTarget = true end

        lu.assertIsNil(targetList.invokedLoadTargets)
        lu.assertIsNil(targetList.invokedLoadCurrentIndex)
        lu.assertIsNil(targetList.invokedSanitizeCurrent)
        lu.assertIsNil(targetList.invokedsanitizeMarks)
        lu.assertIsNil(targetList.invokedUpdateMacroWithCurrentTarget)

        targetList:load()

        lu.assertIsTrue(targetList.invokedLoadTargets)
        lu.assertIsTrue(targetList.invokedLoadCurrentIndex)
        lu.assertIsTrue(targetList.invokedSanitizeCurrent)
        lu.assertIsTrue(targetList.invokedsanitizeMarks)
        lu.assertIsTrue(targetList.invokedUpdateMacroWithCurrentTarget)
    end

    -- @covers TargetList:loadCurrentIndex()
    function TestTargetList:testLoadCurrentIndex()
        MultiTargets.__.arr:set(MultiTargets_Data, 'lists.default.current', 2)

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertEquals(targetList.current, 0)

        targetList:loadCurrentIndex()

        lu.assertEquals(targetList.current, 2)
    end

    -- @covers TargetList:loadTargets()
    function TestTargetList:testLoadTargets()
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

    -- @covers TargetList:maybeMark()
    function TestTargetList:testMaybeMark()
        -- @TODO: Keep working here!
    end

    -- @covers TargetList:remove()
    function TestTargetList:testRemove()
        local function execution(targets, name, expectedTargets)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
            targetList.targets = targets
            targetList.sanitizeCurrent = function () targetList.sanitizeCurrentInvoked = true end
            targetList.sanitizeMarks = function () targetList.sanitizeMarksInvoked = true end
            targetList.save = function () targetList.saveInvoked = true end

            targetList:remove(name)

            lu.assertEquals(targetList.targets, expectedTargets)
            lu.assertIsTrue(targetList.sanitizeCurrentInvoked)
            lu.assertIsTrue(targetList.sanitizeMarksInvoked)
            lu.assertIsTrue(targetList.saveInvoked)
        end

        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

        execution({}, 'test-target-1', {})
        execution({targetA}, 'test-target-a', {})
        execution({targetA}, 'test-target-b', {targetA})
        execution({targetA, targetB}, 'test-target-a', {targetB})
    end

    -- @covers TargetList:rotate()
    function TestTargetList:testRotate()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.sanitizeCurrent = function () end
        targetList.updateMacroWithCurrentTarget = function () end
        targetList.save = function () end

        targetList.current = 5

        targetList:rotate()

        lu.assertEquals(targetList.current, 6)
    end

    -- @covers TargetList:sanitizeCurrent()
    function TestTargetList:testSanitizeCurrent()
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

    -- @covers TargetList:sanitizeMarks()
    function TestTargetList:testSanitizeMarks()
        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-2')
        local targetC = MultiTargets.__:new('MultiTargetsTarget', 'test-target-3')

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.targets = {targetA, targetB, targetC}

        targetList:sanitizeMarks()

        lu.assertEquals(targetA.raidMarker, MultiTargets.__.raidMarkers.skull)
        lu.assertEquals(targetB.raidMarker, MultiTargets.__.raidMarkers.x)
        lu.assertEquals(targetC.raidMarker, MultiTargets.__.raidMarkers.square)
    end

    -- @covers TargetList:save()
    function TestTargetList:testSave()
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
    function TestTargetList:testUpdateMacroWithCurrentTarget()
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