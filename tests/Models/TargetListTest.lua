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

    lu.assertIsNil(targetList.current)

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