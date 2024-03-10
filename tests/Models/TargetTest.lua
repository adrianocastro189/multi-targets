--[[
@covers Target.getMacroBody()
]]
function testTargetCanGetMacroBody()
    local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

    local macroBody = target:getMacroBody()

    lu.assertEquals(macroBody, {
        '/cleartarget',
        '/target [nodead] test-name',
        '/script __h = UnitHealth("target") == UnitHealthMax("target")',
        '/script if __h then SetRaidTarget("target",8) end',
        '/run C_Timer.After(0.1, function() SQRN_NextTarget() end)',
    })
end

--[[
@covers Target.__construct()
]]
function testTargetCanInstantiateTarget()
    local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

    lu.assertNotIsNil(target)
    lu.assertEquals(target.name, 'test-name')
end