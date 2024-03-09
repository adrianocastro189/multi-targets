--[[
@covers Target.__construct()
]]
function testTargetCanInstantiateTarget()
    local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

    lu.assertNotIsNil(target)
    lu.assertEquals(target.name, 'test-name')
end