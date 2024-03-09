--[[
@covers TargetList.__construct()
]]
function testTargetListCanInstantiateTargetList()
    local targetList = MultiTargets.__:new('MultiTargetsTargetList')

    lu.assertNotIsNil(targetList)
end