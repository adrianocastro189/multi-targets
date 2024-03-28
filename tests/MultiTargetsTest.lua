TestMultiTargets = {}
    -- @covers MultiTargets:invokeOnCurrent()
    function TestMultiTargets:testInvokeOnCurrent()
        local originalTargetList = MultiTargets.currentTargetList

        MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
        MultiTargets.currentTargetList.updateMacroWithCurrentTarget = function () end

        local target = MultiTargets.__:new('MultiTargetsTarget', 'test-target-1')

        MultiTargets:invokeOnCurrent('add', 'test-target-1')

        lu.assertEquals(MultiTargets.currentTargetList.targets, {target})

        MultiTargets:invokeOnCurrent('remove', 'test-target-1')

        lu.assertEquals(MultiTargets.currentTargetList.targets, {})

        -- emulates the target list not being loaded
        MultiTargets.currentTargetList = nil

        -- should not throw an error
        MultiTargets:invokeOnCurrent('add', 'test-target-1')

        MultiTargets.currentTargetList = originalTargetList
    end

    -- @covers MultiTargets:out()
    function TestMultiTargets:testOut()
        local originalOutput = MultiTargets.__.output

        local libraryOutInvoked = false

        function MultiTargets.__.output:out(message)
            libraryOutInvoked = message
        end

        MultiTargets:out('test message')

        lu.assertEquals(libraryOutInvoked, 'test message')

        MultiTargets.__.output = originalOutput
    end
-- end of MultiTargetsTest