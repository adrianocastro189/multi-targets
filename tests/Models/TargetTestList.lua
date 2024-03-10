--[[
@covers TargetList.__construct()
]]
function testTargetListCanInstantiateTargetList()
    local targetList = MultiTargets.__:new('MultiTargetsTargetList')

    lu.assertNotIsNil(targetList)
    lu.assertEquals(targetList.targets, {})
end

--[[
@covers TargetList:load()
]]
function testTargetListCanLoad()
    MultiTargets_Data = {}
    MultiTargets.__.arr:set(MultiTargets_Data, 'lists.default.targets', {
        'test-target-1',
        'test-target-2',
        'test-target-3',
    })

    local targetList = MultiTargets.__:new('MultiTargetsTargetList')

    lu.assertEquals(#targetList.targets, 0)

    targetList:load('default')

    local targets = targetList.targets

    -- @TODO: Compare list of targets
    -- will left as failing to remind updating it
    lu.assertEquals(#targetList.targets, 0)

    MultiTargets_Data = nil
end