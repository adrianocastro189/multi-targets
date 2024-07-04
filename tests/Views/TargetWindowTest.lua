TestTargetWindow = BaseTestClass:new()
    -- @covers TargetWindow:__construct()
    function TestTargetWindow:testConstruct()
        local instance = MultiTargets.__:new('MultiTargets/TargetWindow')

        lu.assertNotNil(instance)
        lu.assertEquals('targets-window', instance.id)
        lu.assertEquals({}, instance.items)
        lu.assertIsNil(instance.targetList)
        -- confirm that the instance is a subclass of Window
        lu.assertIsFunction(instance.create)

        lu.assertEquals({}, instance.contentChildren)
        lu.assertEquals({
            point = 'CENTER',
            relativePoint = 'CENTER',
            xOfs = 0,
            yOfs = 0
        }, instance.firstPosition)
        lu.assertEquals(250, instance.firstSize.width)
        lu.assertEquals(400, instance.firstSize.height)
        lu.assertIsTrue(instance.firstVisibility)
        lu.assertIsTrue(instance.persistStateByPlayer)
        lu.assertEquals('MultiTargets', instance.title)
    end

    -- @covers TargetWindow:createEmptyTargetListMessage()
    function TestTargetWindow:testCreateEmptyTargetListMessage()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        local emptyTargetListMessage = window:createEmptyTargetListMessage()

        lu.assertNotIsNil(emptyTargetListMessage)
    end

    -- @covers TargetWindow:handleTargetListRefreshEvent()
    function TestTargetWindow:testHandleTargetListRefreshEvent()
        local function execution(action, shouldSetVisibility)
            local targetList = MultiTargets.__:new('MultiTargets/TargetList', 'test-target-list')
            local window = MultiTargets.__:new('MultiTargets/TargetWindow')
    
            window.setVisibilityInvoked = false

            window.setTargetList = function(self, targetListArg) window.targetListArg = targetListArg end
            window.setVisibility = function() window.setVisibilityInvoked = true end
    
            window:handleTargetListRefreshEvent(targetList, action)
    
            lu.assertEquals(targetList, window.targetListArg)
            lu.assertEquals(shouldSetVisibility, window.setVisibilityInvoked)
        end

        execution('add', true)
        execution('test-action', false)
    end

    -- @covers TargetWindow:maybeAllocateItems()
    function TestTargetWindow:testMaybeAllocateItems()
        local function execution(items, targets, expectedItemsCount)
            local window = MultiTargets.__:new('MultiTargets/TargetWindow')

            window.items = items
            window.targetList = {targets = targets}
            window.setContent = function(self, content) self.content = content end

            MultiTargets.__.arr.pluck = function() return {'pluck-result'} end

            window:maybeAllocateItems()

            lu.assertEquals(expectedItemsCount, #window.items)
            lu.assertEquals({'pluck-result'}, window.content)
        end

        execution({}, {'a', 'b', 'c'}, 3)
        execution({'a', 'b', 'c'}, {'a', 'b', 'c'}, 3)
        execution({'a', 'b', 'c', 'd'}, {'a', 'b', 'c'}, 4)
    end

    -- @covers TargetWindow:maybeCreateEmptyTargetListMessage()
    function TestTargetWindow:testMaybeCreateEmptyTargetListMessage()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        local callCount = 0

        window.createEmptyTargetListMessage = function(self)
            callCount = callCount + 1
            return {'empty-target-list-message'}
        end

        window:maybeCreateEmptyTargetListMessage()

        lu.assertEquals({'empty-target-list-message'}, window.emptyTargetListMessage)

        window:maybeCreateEmptyTargetListMessage()

        lu.assertEquals(1, callCount)
    end

    -- @covers TargetWindow:maybeShowEmptyTargetListMessage()
    function TestTargetWindow:testMaybeShowEmptyTargetListMessage()
        local function execution(targetList, shouldSetContent, shouldHide)
            local window = MultiTargets.__:new('MultiTargets/TargetWindow')

            window.emptyTargetListMessage = {
                hideInvoked = false,
                showInvoked = false,
                Show = function(self) self.showInvoked = true end,
                Hide = function(self) self.hideInvoked = true end
            }
            window.maybeCreateEmptyTargetListMessage = function(self) self.maybeCreateEmptyTargetListMessageCalled = true end
            window.targetList = targetList

            window.setContent = function (self, content) self.content = content end

            window:maybeShowEmptyTargetListMessage()

            if shouldSetContent then
                lu.assertEquals({ window.emptyTargetListMessage }, window.content)
            else
                lu.assertIsNil(window.content)
            end
            
            lu.assertIsTrue(window.maybeCreateEmptyTargetListMessageCalled)
            lu.assertEquals(shouldSetContent, window.emptyTargetListMessage.showInvoked)
            lu.assertEquals(shouldHide, window.emptyTargetListMessage.hideInvoked)
        end

        local emptyTargetList = { isEmpty = function () return true end }
        local nonEmptyTargetList = { isEmpty = function () return false end }

        execution(emptyTargetList, true, false)
        execution(nonEmptyTargetList, false, true)
    end

    -- @covers TargetWindow:observeTargetListRefreshings()
    function TestTargetWindow:testObserveTargetListRefreshings()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        local targetList = MultiTargets.__:new('MultiTargets/TargetList', 'test-target-list')

        window.handleTargetListRefreshEvent = function(self, targetListArg, actionArg)
            window.actionArg = actionArg
            window.targetListArg = targetListArg
        end

        MultiTargets.__.events:notify('TARGET_LIST_REFRESHED', targetList, 'test-action')

        lu.assertEquals('test-action', window.actionArg)
        lu.assertEquals(targetList, window.targetListArg)
    end

    -- @covers TargetWindow:renderTargetList()
    function TestTargetWindow:testRenderTargetList()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        window.targetList = {targets = {'target-a'}}

        local itemA = MultiTargets.__:new('MultiTargets/TargetWindowItem')
        local itemB = MultiTargets.__:new('MultiTargets/TargetWindowItem')

        itemA.setTarget = function(self, target) self.target = target end
        itemB.setTarget = function(self, target) self.target = target end

        window.items = {itemA, itemB}

        window:renderTargetList()

        lu.assertEquals('target-a', itemA.target)
        lu.assertIsNil(itemB.target)
    end

    -- @covers TargetWindow:setTargetList()
    function TestTargetWindow:testSetTargetList()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        window.maybeAllocateItems = function(self) window.maybeAllocateItemsCalled = true end
        window.maybeShowEmptyTargetListMessage = function(self) window.maybeShowEmptyTargetListMessageCalled = true end
        window.renderTargetList = function(self) window.renderTargetListCalled = true end

        local targetList = MultiTargets.__:new('MultiTargets/TargetList', 'test-target-list')

        window:setTargetList(targetList)

        lu.assertEquals(targetList, window.targetList)
        lu.assertIsTrue(window.maybeAllocateItemsCalled)
        lu.assertIsTrue(window.maybeShowEmptyTargetListMessageCalled)
        lu.assertIsTrue(window.renderTargetListCalled)
    end
-- end of TestClassName