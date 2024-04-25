TestTargetList = BaseTestClass:new()
    -- @covers TargetList:add()
    function TestTargetList:testAdd()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        targetList.refreshState = function () targetList.refreshStateInvoked = true end

        lu.assertIsNil(targetList.refreshStateInvoked)

        local addedMessage = 'test-new-target added to the target list'
        local alreadyAddedMessage = 'test-new-target is already in the target list'

        lu.assertIsFalse(MultiTargets.__.output:printed(addedMessage))
        lu.assertIsFalse(MultiTargets.__.output:printed(alreadyAddedMessage))

        -- will try two times to test if add() won't add duplicate names
        targetList:add('test-new-target')
        lu.assertIsTrue(MultiTargets.__.output:printed(addedMessage))
        lu.assertIsFalse(MultiTargets.__.output:printed(alreadyAddedMessage))
        targetList:add('test-new-target')
        lu.assertIsTrue(MultiTargets.__.output:printed(alreadyAddedMessage))

        local expectedTargets = MultiTargets.__:new('MultiTargetsTarget', 'test-new-target')

        lu.assertEquals({expectedTargets}, targetList.targets)
        lu.assertIsTrue(targetList.refreshStateInvoked)
    end

    -- @covers TargetList:add()
    -- @covers TargetList:remove()
    function TestTargetList:testAddAndRemoveWithInvalidName()
        local function execution(method, name)
            -- @TODO: Remove this once every test resets the MultiTargets
            -- instance, even for test with providers <2024.04.09>
            MultiTargets.__.output.history = {}

            local message = 'Invalid target name'

            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
    
            lu.assertIsFalse(MultiTargets.__.output:printed(message))
    
            targetList[method](name)
            
            lu.assertTrue(MultiTargets.__.output:printed(message))
        end

        execution('add', nil)
        execution('add', '')
        execution('add', ' ')
        execution('remove', nil)
        execution('remove', '')
        execution('remove', ' ')
    end

    -- @covers TargetList:addTargetted()
    function TestTargetList:testAddTargetted()
        local function execution(targettedName, shouldInvokeAdd)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
            targetList.addInvoked = false
            targetList.add = function () targetList.addInvoked = true end

            MultiTargets.__.target = {
                getName = function () return targettedName end
            }

            targetList:addTargetted()

            lu.assertEquals(shouldInvokeAdd, targetList.addInvoked)
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
        lu.assertTrue(MultiTargets.__.output:printed('Target list cleared successfully'))
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

        targetList.maybeInitializeData = function () targetList.invokedMaybeInitializeData = true end
        targetList.loadTargets = function () targetList.invokedLoadTargets = true end
        targetList.loadCurrentIndex = function () targetList.invokedLoadCurrentIndex = true end
        targetList.refreshState = function () targetList.invokedRefreshState = true end

        lu.assertIsNil(targetList.invokedMaybeInitializeData)
        lu.assertIsNil(targetList.invokedLoadTargets)
        lu.assertIsNil(targetList.invokedLoadCurrentIndex)
        lu.assertIsNil(targetList.invokedRefreshState)

        targetList:load()

        lu.assertIsTrue(targetList.invokedMaybeInitializeData)
        lu.assertIsTrue(targetList.invokedLoadTargets)
        lu.assertIsTrue(targetList.invokedLoadCurrentIndex)
        lu.assertIsTrue(targetList.invokedRefreshState)
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

    -- @covers TargetList:maybeInitializeData()
    function TestTargetList:testMaybeInitializeData()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'test-target-list')

        lu.assertIsNil(MultiTargets.__.arr:get(MultiTargets_Data, targetList.targetsDataKey))
        lu.assertIsNil(MultiTargets.__.arr:get(MultiTargets_Data, targetList.currentDataKey))

        targetList:maybeInitializeData()

        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.targetsDataKey), {})
        lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.currentDataKey), 0)
    end

    -- @covers TargetList:maybeMark()
    function TestTargetList:testMaybeMark()
        -- @TODO: Keep working here!
    end

    -- @covers TargetList:print()
    function TestTargetList:testPrint()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
        targetList:print()

        lu.assertTrue(MultiTargets.__.output:printed('There are no targets in the target list'))
        
        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

        targetList.targets = {targetA, targetB}

        targetList:print()

        lu.assertTrue(MultiTargets.__.output:printed('Target #1 - ' .. targetA:getPrintableString()))
        lu.assertTrue(MultiTargets.__.output:printed('Target #2 - ' .. targetB:getPrintableString()))
    end

    -- @covers TargetList:refreshState()
    function TestTargetList:testRefreshState()
        local sanitizeCurrentInvoked = false
        local sanitizeMarksInvoked = false
        local saveInvoked = false
        local updateMacroWithCurrentTargetInvoked = false

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.sanitizeCurrent = function () sanitizeCurrentInvoked = true end
        targetList.sanitizeMarks = function () sanitizeMarksInvoked = true end
        targetList.save = function () saveInvoked = true end
        targetList.updateMacroWithCurrentTarget = function () updateMacroWithCurrentTargetInvoked = true end

        targetList:refreshState()

        lu.assertIsTrue(sanitizeCurrentInvoked)
        lu.assertIsTrue(sanitizeMarksInvoked)
        lu.assertIsTrue(saveInvoked)
        lu.assertIsTrue(updateMacroWithCurrentTargetInvoked)
    end

    -- @covers TargetList:remove()
    function TestTargetList:testRemove()
        local function execution(targets, name, expectedTargets, expectedOutput)
            -- @TODO: Remove this once every test resets the MultiTargets instance <2024.04.09>
            MultiTargets.__.output.history = {}

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
            lu.assertTrue(MultiTargets.__.output:printed(expectedOutput))
        end

        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

        execution({}, 'test-target-1', {}, 'test-target-1 is not in the target list')
        execution({targetA}, 'test-target-a', {}, 'test-target-a removed from the target list')
        execution({targetA}, 'test-target-b', {targetA}, 'test-target-b is not in the target list')
        execution({targetA, targetB}, 'test-target-a', {targetB}, 'test-target-a removed from the target list')
    end

    -- @covers TargetList:removeTargetted()
    function TestTargetList:testRemoveTargetted()
        local function execution(targettedName, shouldInvokeRemove)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
            targetList.removeInvoked = false
            targetList.remove = function () targetList.removeInvoked = true end

            MultiTargets.__.target = {
                getName = function () return targettedName end
            }

            targetList:removeTargetted()

            lu.assertEquals(shouldInvokeRemove, targetList.removeInvoked)
        end

        execution('test-target-1', true)
        execution(nil, false)
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