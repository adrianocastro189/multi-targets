TestTargetWindow = BaseTestClass:new()
    -- @covers TargetWindow:__construct()
    function TestTargetWindow:testConstruct()
        local instance = MultiTargets.__:new('MultiTargetsTargetWindow')

        lu.assertNotNil(instance)
        lu.assertEquals(instance.id, 'targets-window')
        lu.assertEquals(instance.items, {})
        lu.assertIsNil(instance.targetList)
        -- confirm that the instance is a subclass of Window
        lu.assertIsFunction(instance.create)

        lu.assertEquals(instance.contentChildren, {})
        lu.assertEquals(instance.firstPosition, {
            point = 'CENTER',
            relativePoint = 'CENTER',
            xOfs = 0,
            yOfs = 0
        })
        lu.assertEquals(instance.firstSize.width, 250)
        lu.assertEquals(instance.firstSize.height, 400)
        lu.assertIsTrue(instance.firstVisibility)
        lu.assertEquals(instance.title, 'MultiTargets')
    end

    -- @covers TargetWindow:handleTargetListRefreshEvent()
    function TestTargetWindow:testHandleTargetListRefreshEvent()
        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'test-target-list')
        local window = MultiTargets.__:new('MultiTargetsTargetWindow')

        window.setTargetList = function(self, targetListArg) window.targetListArg = targetListArg end

        window:handleTargetListRefreshEvent(targetList)

        lu.assertEquals(window.targetListArg, targetList)
    end

    -- @covers TargetWindow:maybeAllocateItems()
    function TestTargetWindow:testMaybeAllocateItems()
        local function execution(items, targets, expectedItemsCount)
            local window = MultiTargets.__:new('MultiTargetsTargetWindow')

            window.items = items
            window.targetList = {targets = targets}
            window.setContent = function(self, content) self.content = content end

            MultiTargets.__.arr.pluck = function() return {'pluck-result'} end

            window:maybeAllocateItems()

            lu.assertEquals(#window.items, expectedItemsCount)
            lu.assertEquals(window.content, {'pluck-result'})
        end

        execution({}, {'a', 'b', 'c'}, 3)
        execution({'a', 'b', 'c'}, {'a', 'b', 'c'}, 3)
        execution({'a', 'b', 'c', 'd'}, {'a', 'b', 'c'}, 4)
    end

    -- @covers TargetWindow:observeTargetListRefreshings()
    function TestTargetWindow:testObserveTargetListRefreshings()
        local window = MultiTargets.__:new('MultiTargetsTargetWindow')

        local targetList = MultiTargets.__:new('MultiTargetsTargetList', 'test-target-list')

        window.handleTargetListRefreshEvent = function(self, targetListArg)
            window.targetListArg = targetListArg
        end

        MultiTargets.__.events:notify('TARGET_LIST_REFRESHED', targetList)

        lu.assertEquals(window.targetListArg, targetList)
    end
-- end of TestClassName