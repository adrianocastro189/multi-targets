TestTarget = {}
    -- @covers Target.getMacroBody()
    function TestTarget:testCanGetMacroBody()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        local macroBody = target:getMacroBody()

        lu.assertEquals(macroBody, {
            '/cleartarget',
            '/target [nodead] test-name',
            '/script __h = UnitHealth("target") == UnitHealthMax("target")',
            '/script if __h then SetRaidTarget("target",8) end',
            '/run C_Timer.After(0.1, function() MultiTargets:rotate() end)',
        })
    end

    -- @covers Target.__construct()
    function TestTarget:testCanInstantiateTarget()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        lu.assertNotIsNil(target)
        lu.assertEquals(target.name, 'test-name')
    end
-- end of TestTarget