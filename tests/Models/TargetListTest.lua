-- @see testTargetListCanDetermineCurrentIsValid
local function testTargetListCanDetermineCurrentIsValidExecution(targets, current, expectedResult)
    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    targetList.targets = targets
    targetList.current = current

    lu.assertEquals(targetList:currentIsValid(), expectedResult)
end

--[[
@covers TargetList:currentIsValid()
]]
function testTargetListCanDetermineCurrentIsValid()
    testTargetListCanDetermineCurrentIsValidExecution({}, 0, false)
    testTargetListCanDetermineCurrentIsValidExecution({'t-1'}, 0, false)
    testTargetListCanDetermineCurrentIsValidExecution({'t-1'}, 1, true)
    testTargetListCanDetermineCurrentIsValidExecution({'t-1'}, 2, false)
    testTargetListCanDetermineCurrentIsValidExecution({'t-1', 't-2'}, 2, true)
    testTargetListCanDetermineCurrentIsValidExecution({'t-1', 't-2'}, 3, false)
end

-- @see testTargetListCanDetermineIsEmpty
local function testTargetListCanDetermineIsEmptyExecution(targets, expectedResult)
    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    targetList.targets = targets

    lu.assertEquals(targetList:isEmpty(), expectedResult)
end

--[[
@covers TargetList:isEmpty()
]]
function testTargetListCanDetermineIsEmpty()
    testTargetListCanDetermineIsEmptyExecution({}, true)
    testTargetListCanDetermineIsEmptyExecution({'t-1'}, false)
end

--[[
@covers TargetList.__construct()
]]
function testTargetListCanInstantiateTargetList()
    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    lu.assertNotIsNil(targetList)
    lu.assertEquals(targetList.listName, 'default')
    lu.assertEquals(targetList.targets, {})
end

--[[
@covers TargetList:load()
]]
function testTargetListCanLoad()
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

--[[
@covers TargetList:loadCurrentIndex()
]]
function testTargetListCanLoadCurrentIndex()
    MultiTargets_Data = {}
    MultiTargets.__.arr:set(MultiTargets_Data, 'lists.default.current', 2)

    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    lu.assertEquals(targetList.current, 0)

    targetList:loadCurrentIndex()

    lu.assertEquals(targetList.current, 2)

    MultiTargets_Data = nil
end

--[[
@covers TargetList:loadTargets()
]]
function testTargetListCanLoadTargets()
    MultiTargets_Data = {}
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

    MultiTargets_Data = nil
end

--[[
@covers TargetList:rotate()
]]
function testTargetListCanRotate()
    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    targetList.sanitizeCurrent = function () end
    targetList.updateMacroWithCurrentTarget = function () end

    targetList.current = 5

    targetList:rotate()

    lu.assertEquals(targetList.current, 6)
end

-- @see testTargetListCanSanitizeCurrent
local function testTargetListCanSanitizeCurrentExecution(isEmpty, currentIsValid, current, expectedCurrent)
    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    targetList.isEmpty = function () return isEmpty end
    targetList.currentIsValid = function () return currentIsValid end
    targetList.current = current

    targetList:sanitizeCurrent()

    lu.assertEquals(targetList.current, expectedCurrent)
end

--[[
@covers TargetList:sanitizeCurrent()
]]
function testTargetListCanSanitizeCurrent()
    -- isEmpty, so current must be zero
    testTargetListCanSanitizeCurrentExecution(true, true, 1, 0)

    -- current is valid, so current must be not changed
    testTargetListCanSanitizeCurrentExecution(false, true, 1, 1)

    -- is not empty and current is not valid, so it resets
    testTargetListCanSanitizeCurrentExecution(false, false, 2, 1)
end

--[[
@covers TargetList:save()
]]
function testTargetListCanSave()
    MultiTargets_Data = {}

    local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')

    local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-target-a')
    local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-target-b')

    targetList.targets = {targetA, targetB}
    targetList.current = 2

    targetList:save()

    lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.targetsDataKey), {'test-target-a', 'test-target-b'})
    lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, targetList.currentDataKey), 2)

    MultiTargets_Data = nil
end

--[[
@covers TargetList:updateMacroWithCurrentTarget()
]]
function testTargetListCanUpdateMacroWithCurrentTarget()
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