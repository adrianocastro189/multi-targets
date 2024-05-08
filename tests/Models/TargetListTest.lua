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

        lu.assertEquals({}, targetList.targets)
        lu.assertEquals(0, targetList.current)
        lu.assertIsTrue(targetList.saveInvoked)
        lu.assertTrue(MultiTargets.__.output:printed('Target list cleared successfully'))
    end

    -- @covers TargetList:currentIsValid()
    function TestTargetList:testCurrentIsValid()
        local execution = function (targets, current, expectedResult)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

            targetList.targets = targets
            targetList.current = current
        
            lu.assertEquals(expectedResult, targetList:currentIsValid())
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
        lu.assertEquals('default', targetList.listName)
        lu.assertEquals({}, targetList.targets)
    end

    -- @covers TargetList:isEmpty()
    function TestTargetList:testIsEmpty()
        local execution = function (targets, expectedResult)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
            targetList.targets = targets
        
            lu.assertEquals(expectedResult, targetList:isEmpty())
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
        MultiTargets.__:playerConfig({['lists.default.current'] = 2})

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertEquals(0, targetList.current)

        targetList:loadCurrentIndex()

        lu.assertEquals(2, targetList.current)
    end

    -- @covers TargetList:loadTargets()
    function TestTargetList:testLoadTargets()
        MultiTargets.__:playerConfig({['lists.default.targets'] = {
            'test-target-1',
            'test-target-2',
            'test-target-3',
        }})

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        lu.assertEquals(0, #targetList.targets)

        targetList:loadTargets()

        local targets = targetList.targets

        lu.assertEquals({
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-1'),
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-2'),
            MultiTargets.__:new('MultiTargetsTarget', 'test-target-3'),
        }, targets)
    end

    -- @covers TargetList:maybeInitializeData()
    function TestTargetList:testMaybeInitializeData()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'test-target-list')

        lu.assertIsNil(MultiTargets.__:playerConfig(targetList.targetsDataKey))
        lu.assertIsNil(MultiTargets.__:playerConfig(targetList.currentDataKey))

        targetList:maybeInitializeData()

        lu.assertEquals({}, MultiTargets.__:playerConfig(targetList.targetsDataKey))
        lu.assertEquals(0, MultiTargets.__:playerConfig(targetList.currentDataKey))
    end

    -- @covers TargetList:maybeMark()
    function TestTargetList:testMaybeMark()
        local target1 = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')
        local target2 = MultiTargets.__:new('MultiTargetsTarget', 'test-target-2')
        local target3 = MultiTargets.__:new('MultiTargetsTarget', 'test-target-3')

        target1.maybeMark = function () target1.invokedMaybeMark = true return false end
        target2.maybeMark = function () target2.invokedMaybeMark = true return true end
        target3.maybeMark = function () target3.invokedMaybeMark = true return false end

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        targetList.targets = {target1, target2, target3}

        lu.assertIsNil(target1.invokedMaybeMark)
        lu.assertIsNil(target2.invokedMaybeMark)
        lu.assertIsNil(target3.invokedMaybeMark)

        targetList:maybeMark()

        lu.assertIsTrue(target1.invokedMaybeMark)
        lu.assertIsTrue(target2.invokedMaybeMark)
        lu.assertIsNil(target3.invokedMaybeMark)
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

        local eventBroadcasted = nil
        local eventTargetListInstance = nil

        MultiTargets.__.events.notify = function (self, event, targetList)
            eventBroadcasted = event
            eventTargetListInstance = targetList
        end

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

        lu.assertEquals('TARGET_LIST_REFRESHED', eventBroadcasted)
        lu.assertEquals(targetList, eventTargetListInstance)
    end

    -- @covers TargetList:remove()
    function TestTargetList:testRemove()
        local function execution(targets, name, expectedTargets, expectedOutput)
            -- @TODO: Remove this once every test resets the MultiTargets instance <2024.04.09>
            MultiTargets.__.output.history = {}

            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
            targetList.targets = targets
            targetList.refreshState = function () targetList.refreshStateInvoked = true end

            targetList:remove(name)

            lu.assertEquals(expectedTargets, targetList.targets)
            lu.assertIsTrue(targetList.refreshStateInvoked)
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

        targetList.refreshState = function () targetList.refreshStateInvoked = true end

        targetList.current = 5

        targetList:rotate()

        lu.assertEquals(6, targetList.current)
        lu.assertIsTrue(targetList.refreshStateInvoked)
    end

    -- @covers TargetList:sanitizeCurrent()
    function TestTargetList:testSanitizeCurrent()
        local function execution(isEmpty, currentIsValid, current, expectedCurrent)
            local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        
            targetList.isEmpty = function () return isEmpty end
            targetList.currentIsValid = function () return currentIsValid end
            targetList.current = current
        
            targetList:sanitizeCurrent()
        
            lu.assertEquals(expectedCurrent, targetList.current)
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

        lu.assertEquals(MultiTargets.__.raidMarkers.skull, targetA.raidMarker)
        lu.assertEquals(MultiTargets.__.raidMarkers.x, targetB.raidMarker)
        lu.assertEquals(MultiTargets.__.raidMarkers.square, targetC.raidMarker)
    end

    -- @covers TargetList:save()
    function TestTargetList:testSave()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

        targetList.targets = {targetA, targetB}
        targetList.current = 2

        targetList:save()

        lu.assertEquals({'test-target-a', 'test-target-b'}, MultiTargets.__:playerConfig(targetList.targetsDataKey))
        lu.assertEquals(2, MultiTargets.__:playerConfig(targetList.currentDataKey))
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