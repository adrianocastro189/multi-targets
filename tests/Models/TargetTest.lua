TestTarget = BaseTestClass:new()
    -- @covers Target.__construct()
    function TestTarget:testConstructor()
        local function execution(constructorArg, expectedName)
            local target = MultiTargets:new('MultiTargets/Target', constructorArg)

            lu.assertNotIsNil(target)
            lu.assertEquals(expectedName, target.name)
            lu.assertEquals(MultiTargets.raidMarkers.skull, target.raidMarker)
        end

        execution('test-name', 'test-name')
        execution(MultiTargets:new('MultiTargets/Target', 'test-name-from-instance'), 'test-name-from-instance')
    end

    -- @covers Target:__eq()
    function TestTarget:testEquals()
        local targetA = MultiTargets:new('MultiTargets/Target', 'test-name')
        local targetB = MultiTargets:new('MultiTargets/Target', 'test-another-name')
        local targetC = MultiTargets:new('MultiTargets/Target', 'test-name')

        lu.assertEquals(targetA, targetA)
        lu.assertEquals(targetA, targetC)
        lu.assertNotEquals(targetA, targetB)
        lu.assertIsTrue(targetA == targetC)
        lu.assertIsFalse(targetA == targetB)
    end

    -- @covers Target:getMacroBody()
    function TestTarget:testGetMacroBody()
        local target = MultiTargets:new('MultiTargets/Target', 'test-name')

        local macroBody = target:getMacroBody()

        lu.assertEquals({
            '/cleartarget',
            '/target test-name',
            '/cleartarget [dead]',
            "/run MultiTargets:invokeOnCurrent('maybeMark')",
            "/run C_Timer.After(0.1, function() MultiTargets:invokeOnCurrent('rotate') end)",
        }, macroBody)
    end

    -- @covers Target:getPrintableString()
    function TestTarget:testGetPrintableString()
        local function execution(target, expectedOutput)
            lu.assertEquals(expectedOutput, target:getPrintableString())
        end

        local target = MultiTargets:new('MultiTargets/Target', 'test-name')

        execution(target, MultiTargets.raidMarkers.skull:getPrintableString() .. ' ' .. 'test-name')

        target.raidMarker = nil

        execution(target, 'test-name')
    end

    -- @covers Target:isAlreadyMarked()
    function TestTarget:testIsAlreadyMarked()
        local function execution(facadeMark, instanceMark, expectedResult)
            MultiTargets.target.getMark = function () return facadeMark end

            local target = MultiTargets:new('MultiTargets/Target', 'test-name')

            target:setRaidMarker(instanceMark)

            lu.assertEquals(expectedResult, target:isAlreadyMarked())
        end

        execution(nil, nil, false)
        execution(nil, MultiTargets.raidMarkers.skull, false)
        execution(MultiTargets.raidMarkers.skull, nil, false)
        execution(MultiTargets.raidMarkers.skull, MultiTargets.raidMarkers.x, false)
        execution(MultiTargets.raidMarkers.skull, MultiTargets.raidMarkers.skull, true)
    end

    -- @covers Target:isTargetted()
    function TestTarget:testIsTargetted()
        local function execution(targettedName, targetName, expectedResult)
            local target = MultiTargets:new('MultiTargets/Target', targetName)

            MultiTargets.target = {
                getName = function () return targettedName end
            }

            lu.assertEquals(expectedResult, target:isTargetted())
        end

        execution('test-name', 'test-name', true)
        execution('test-name', 'test-another-name', false)
    end

    -- @covers Target:maybeMark()
    function TestTarget:testMaybeMark()
        local function execution(shouldMark)
            local target = MultiTargets:new('MultiTargets/Target', 'test-name')
            target.markInvoked = false
            target.shouldMark = function () return shouldMark end
            target.mark = function () target.markInvoked = true end

            local result = target:maybeMark()

            lu.assertEquals(shouldMark, target.markInvoked)
            lu.assertEquals(shouldMark, result)
        end

        execution(true)
        execution(false)
    end

    -- @covers Target:setRaidMarker()
    function TestTarget:testSetRaidMarker()
        local target = MultiTargets:new('MultiTargets/Target', 'test-name')

        local skullMarker = MultiTargets.raidMarkers.skull

        target:setRaidMarker(skullMarker)

        lu.assertEquals(skullMarker, target.raidMarker)
    end

    -- @covers Target:shouldMark()
    function TestTarget:testShouldMark()
        local function execution(isTargetted, isTaggable, isAlreadyMarked, expectedResult)
            MultiTargets.target.isTaggable = function () return isTaggable end

            local target = MultiTargets:new('MultiTargets/Target', 'test-name')
            target.isAlreadyMarked = function () return isAlreadyMarked end
            target.isTargetted = function () return isTargetted end

            lu.assertEquals(expectedResult, target:shouldMark())
        end

        -- targetted, taggable, not already marked, so should mark
        execution(true, true, false, true)

        -- scenarios for not marking
        execution(false, true, false, false)  -- not targetted, taggable, not already marked
        execution(true, false, false, false)  -- targetted, not taggable, not already marked
        execution(true, true, true, false)    -- targetted, taggable, already marked
        execution(false, false, false, false) -- not targetted, not taggable, not already marked

    end

    -- @covers Target:updateMacro()
    function TestTarget:testUpdateMacro()
        local macro = {
            updateMacro = function (self, macroBody)
                self.updateMacroInvoked = true
                self.macroBody = macroBody
            end
        }

        local target = MultiTargets:new('MultiTargets/Target', 'test-name')

        target.getMacroBody = function () return 'test-macro-body' end

        function MultiTargets:new(className)
            if className == 'MultiTargets/Macro' then
                return macro
            end
        end

        target:updateMacro()

        lu.assertIsTrue(macro.updateMacroInvoked)
        lu.assertEquals('test-macro-body', macro.macroBody)
    end
-- end of TestTarget