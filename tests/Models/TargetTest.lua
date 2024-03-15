TestTarget = {}
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
            '/target [nodead] test-name',
            '/script __h = UnitHealth("target") == UnitHealthMax("target")',
            '/script if __h then SetRaidTarget("target",8) end',
            '/run C_Timer.After(0.1, function() MultiTargets:rotate() end)',
        })
    end

    -- @covers Target.__construct()
    function TestTarget:testInstantiateTarget()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        lu.assertNotIsNil(target)
        lu.assertEquals(target.name, 'test-name')
        lu.assertEquals(target.markerIcon, MultiTargets.__.target.MARKER_SKULL)
    end

    -- @covers Target:isTargetted()
    function TestTarget:testIsTargetted()
        local function execution(targettedName, targetName, expectedResult)
            local target = MultiTargets.__:new('MultiTargetsTarget', targetName)

            local originalGetTarget = MultiTargets.__.getTarget

            MultiTargets.__.getTarget = function ()
                return {
                    getName = function () return targettedName end
                }
            end

            lu.assertEquals(target:isTargetted(), expectedResult)

            MultiTargets.__.getTarget = originalGetTarget
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

            target:maybeMark()

            lu.assertEquals(target.markInvoked, shouldMark)
        end

        execution(true)
        execution(false)
    end

    -- @covers Target:setMarkerIcon()
    function TestTarget:testSetMarkerIcon()
        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')

        target:setMarkerIcon(1)

        lu.assertEquals(target.markerIcon, 1)
    end

    -- @covers Target:shouldMark()
    function TestTarget:testShouldMark()
        local function execution(isTargetted, isTaggable, expectedResult)
            local originalIsTaggable = MultiTargets.__.target.isTaggable

            MultiTargets.__.target.isTaggable = function () return isTaggable end

            local target = MultiTargets.__:new('MultiTargetsTarget', 'test-name')
            target.isTargetted = function () return isTargetted end

            lu.assertEquals(target:shouldMark(), expectedResult)

            MultiTargets.__.target.isTaggable = originalIsTaggable
        end

        execution(true, false, false)
        execution(false, true, false)
        execution(false, false, false)
        execution(true, true, true)
    end
-- end of TestTarget