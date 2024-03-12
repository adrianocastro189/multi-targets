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