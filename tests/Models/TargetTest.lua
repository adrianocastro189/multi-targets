TestTarget = BaseTestClass:new()
    -- @covers Target:__eq()
    function TestTarget:testEquals()
        local targetA = MultiTargets.__:new('MultiTargetsTarget', 'test-name')
        local targetB = MultiTargets.__:new('MultiTargetsTarget', 'test-another-name')
        local targetC = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        lu.assertEquals(targetA, targetA)
        lu.assertEquals(targetA, targetC)
        lu.assertNotEquals(targetA, targetB)
        lu.assertIsTrue(targetA == targetC)
        lu.assertIsFalse(targetA == targetB)
    end

    -- @covers Target:getMacroBody()
    function TestTarget:testGetMacroBody()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        local macroBody = target:getMacroBody()

        lu.assertEquals(macroBody, {
            '/cleartarget',
            '/target test-name',
            '/cleartarget [dead]',
            "/run MultiTargets:invokeOnCurrent('maybeMark')",
            "/run C_Timer.After(0.1, function() MultiTargets:invokeOnCurrent('rotate') end)",
        })
    end

    -- @covers Target:getPrintableString()
    function TestTarget:testGetPrintableString()
        local function execution(target, expectedOutput)
            lu.assertEquals(target:getPrintableString(), expectedOutput)
        end

        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        execution(target, MultiTargets.__.raidMarkers.skull:getPrintableString() .. ' ' .. 'test-name')

        target.raidMarker = nil

        execution(target, 'test-name')
    end

    -- @covers Target.__construct()
    function TestTarget:testInstantiateTarget()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        lu.assertNotIsNil(target)
        lu.assertEquals(target.name, 'test-name')
        lu.assertEquals(target.raidMarker, MultiTargets.__.raidMarkers.skull)
    end

    -- @covers Target:isAlreadyMarked()
    function TestTarget:testIsAlreadyMarked()
        local function execution(facadeMark, instanceMark, expectedResult)
            MultiTargets.__.target.getMark = function () return facadeMark end

            local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

            target:setRaidMarker(instanceMark)

            lu.assertEquals(target:isAlreadyMarked(), expectedResult)
        end

        execution(nil, nil, false)
        execution(nil, MultiTargets.__.raidMarkers.skull, false)
        execution(MultiTargets.__.raidMarkers.skull, nil, false)
        execution(MultiTargets.__.raidMarkers.skull, MultiTargets.__.raidMarkers.x, false)
        execution(MultiTargets.__.raidMarkers.skull, MultiTargets.__.raidMarkers.skull, true)
    end

    -- @covers Target:isTargetted()
    function TestTarget:testIsTargetted()
        local function execution(targettedName, targetName, expectedResult)
            local target = MultiTargets.__:new('MultiTargetsTarget', targetName)

            MultiTargets.__.target = {
                getName = function () return targettedName end
            }

            lu.assertEquals(target:isTargetted(), expectedResult)
        end

        execution('test-name', 'test-name', true)
        execution('test-name', 'test-another-name', false)
    end

    -- @covers Target:maybeMark()
    function TestTarget:testMaybeMark()
        local function execution(shouldMark)
            local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')
            target.markInvoked = false
            target.shouldMark = function () return shouldMark end
            target.mark = function () target.markInvoked = true end

            local result = target:maybeMark()

            lu.assertEquals(target.markInvoked, shouldMark)
            lu.assertEquals(result, shouldMark)
        end

        execution(true)
        execution(false)
    end

    -- @covers Target:setRaidMarker()
    function TestTarget:testSetRaidMarker()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        local skullMarker = MultiTargets.__.raidMarkers.skull

        target:setRaidMarker(skullMarker)

        lu.assertEquals(target.raidMarker, skullMarker)
    end

    -- @covers Target:shouldMark()
    function TestTarget:testShouldMark()
        local function execution(isTargetted, isTaggable, isAlreadyMarked, expectedResult)
            MultiTargets.__.target.isTaggable = function () return isTaggable end

            local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')
            target.isAlreadyMarked = function () return isAlreadyMarked end
            target.isTargetted = function () return isTargetted end

            lu.assertEquals(target:shouldMark(), expectedResult)
        end

        -- targetted, taggable, not already marked, so should mark
        execution(true, true, false, true)

        -- scenarios for not marking
        execution(false, true, false, false)  -- not targetted, taggable, not already marked
        execution(true, false, false, false)  -- targetted, not taggable, not already marked
        execution(true, true, true, false)    -- targetted, taggable, already marked
        execution(false, false, false, false) -- not targetted, not taggable, not already marked

    end
-- end of TestTarget