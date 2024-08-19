TestTargetWindow = BaseTestClass:new()

-- @covers TargetWindow:__construct()
TestCase.new()
    :setName('__construct')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
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
    end)
    :register()

-- @covers TargetWindow:createEmptyTargetListMessagePage()
TestCase.new()
    :setName('createEmptyTargetListMessagePage')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
        local window = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindow'))
            :mockMethod('addPage')

        local frameSpy = Spy
            .new()
            :mockMethod('SetMultiLine')
            :mockMethod('SetSize')
            :mockMethod('SetPoint')
            :mockMethod('SetFontObject')
            :mockMethod('SetText')
            :mockMethod('SetAutoFocus')
            :mockMethod('SetTextInsets')
            :mockMethod('SetEnabled')
            :mockMethod('Show')

        _G['CreateFrame'] = function () return frameSpy end

        local windowPage = Spy.new()

        windowPage:mockMethod('create', function () return windowPage end)
        windowPage:mockMethod('setContent', function () return windowPage end)

        window.__ = Spy
            .new()
            :mockMethod('new', function () return windowPage end)

        window:createEmptyTargetListMessagePage()

        frameSpy:getMethod('SetMultiLine'):assertCalledOnceWith(true)
        frameSpy:getMethod('SetSize'):assertCalledOnceWith(100, 100)
        frameSpy:getMethod('SetPoint'):assertCalledOnceWith('TOP', 0, 0)
        frameSpy:getMethod('SetFontObject'):assertCalledOnceWith(GameFontNormal)
        frameSpy:getMethod('SetText'):assertCalledOnceWith('There are no targets in the current target list.\n\nAdd targets by clicking the "Add" button when you have an active target or by using the commands listed with the following command:\n\n/multitargets help\n\nIs this your first time using the addon? When you have one or more targets, move the MultiTargets macro to your action bar and assign a hotkey to iterate through the targets in the list.')
        frameSpy:getMethod('SetAutoFocus'):assertCalledOnceWith(false)
        frameSpy:getMethod('SetTextInsets'):assertCalledOnceWith(10, 10, 0, 0)
        frameSpy:getMethod('SetEnabled'):assertCalledOnceWith(false)
        frameSpy:getMethod('Show'):assertCalledOnceWith()

        windowPage:getMethod('create'):assertCalledOnce()
        windowPage:getMethod('setContent'):assertCalledOnceWith({frameSpy})

        window:getMethod('addPage'):assertCalledOnceWith(windowPage)
    end)
    :register()

-- @covers TargetWindow:createTargetWindowComponents
TestCase.new()
    :setName('createTargetWindowComponents')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
        local window = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindow'))
            :mockMethod('addPage')
            :mockMethod('create')
            :mockMethod('createEmptyTargetListMessagePage')
        
        local targetsPage = Spy.new()
        targetsPage:mockMethod('create', function() return targetsPage end)

        MultiTargets.__ = Spy
            .new()
            :mockMethod('new', function () return targetsPage end)

        local result = window:createTargetWindowComponents()

        lu.assertEquals(window, result)

        window:getMethod('create'):assertCalledOnce()
        targetsPage:getMethod('create'):assertCalledOnce()
        window:getMethod('addPage'):assertCalledOnceWith(targetsPage)
        window:getMethod('createEmptyTargetListMessagePage'):assertCalledOnce()
    end)
    :register()

-- @covers TargetWindow:handleTargetListRefreshEvent()
TestCase.new()
    :setName('handleTargetListRefreshEvent')
    :setTestClass(TestTargetWindow)
    :setExecution(function(data)
        local targetList = MultiTargets.__:new('MultiTargets/TargetList', 'test-target-list')
        local window = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindow'))
            :mockMethod('setTargetList')
            :mockMethod('setVisibility')

        window:handleTargetListRefreshEvent(targetList, data.action)

        window:getMethod('setTargetList'):assertCalledOnceWith(targetList)
        
        if (data.shouldSetVisibility) then
            window:getMethod('setVisibility'):assertCalledOnceWith(true)
            return
        end
        
        window:getMethod('setVisibility'):assertNotCalled()
    end)
    :setScenarios({
        ['action is add'] = {
            action = 'add',
            shouldSetVisibility = true
        },
        ['action is not add'] = {
            action = 'test-action',
            shouldSetVisibility = false
        }
    })
    :register()

-- @covers TargetWindow:maybeAllocateItems()
TestCase.new()
    :setName('maybeAllocateItems')
    :setTestClass(TestTargetWindow)
    :setExecution(function(data)
        local windowPage = Spy
            .new()
            :mockMethod('setContent')

        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        window.targetsPage = windowPage

        MultiTargets.__.arr = Spy
            .new(MultiTargets.__.arr)
            :mockMethod('pluck', function() return {'pluck-result'} end)

        window.items = data.items
        window.targetList = {targets = data.targets}

        window:maybeAllocateItems()

        lu.assertEquals(data.expectedItemsCount, #window.items)

        MultiTargets.__.arr:getMethod('pluck'):assertCalledOnceWith(window.items, 'frame')

        window.targetsPage:getMethod('setContent'):assertCalledOnceWith({'pluck-result'})
    end)
    :setScenarios({
        ['no items'] = {
            items = {},
            targets = {'a', 'b', 'c'},
            expectedItemsCount = 3,
        },
        ['items already exist'] = {
            items = {'a', 'b', 'c'},
            targets = {'a', 'b', 'c'},
            expectedItemsCount = 3,
        },
        ['more targets than items'] = {
            items = {'a', 'b', 'c', 'd'},
            targets = {'a', 'b', 'c'},
            expectedItemsCount = 4,
        }
    })
    :register()

-- @covers TargetWindow:observeTargetListRefreshings()
TestCase.new()
    :setName('observeTargetListRefreshings')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
        MultiTargets.__.events = Spy
            .new()
            :mockMethod('listen')

        MultiTargets.__:new('MultiTargets/TargetWindow')

        MultiTargets.__.events:getMethod('listen'):assertCalledOnce()
    end)
    :register()

-- @covers TargetWindow:renderTargetList()
TestCase.new()
    :setName('renderTargetList')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
        local window = MultiTargets.__:new('MultiTargets/TargetWindow')

        window.targetList = {targets = {'target-a'}}

        local itemA = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindowItem'))
            :mockMethod('setTarget')

        local itemB = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindowItem'))
            :mockMethod('setTarget')

        window.items = {itemA, itemB}

        window:renderTargetList()

        itemA:getMethod('setTarget'):assertCalledOnceWith('target-a')
        itemB:getMethod('setTarget'):assertCalledOnceWith(nil)
    end)
    :register()

-- @covers TargetWindow:setTargetWindowActivePage()
TestCase.new()
    :setName('setTargetWindowActivePage')
    :setTestClass(TestTargetWindow)
    :setExecution(function(data)
        local window = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindow'))
            :mockMethod('setActivePage')

        window.emptyPage = {pageId = 'empty-page'}
        window.targetsPage = {pageId = 'targets-page'}
        window.targetList = Spy
            .new()
            :mockMethod('isEmpty', function() return data.isEmpty end)

        window:setTargetWindowActivePage()

        window:getMethod('setActivePage'):assertCalledOnceWith(data.expectedPageId)
    end)
    :setScenarios({
        ['target list is empty'] = {
            isEmpty = true,
            expectedPageId = 'empty-page'
        },
        ['target list is not empty'] = {
            isEmpty = false,
            expectedPageId = 'targets-page'
        }
    })
    :register()

-- @covers TargetWindow:setTargetList()
TestCase.new()
    :setName('setTargetList')
    :setTestClass(TestTargetWindow)
    :setExecution(function()
        local window = Spy
            .new(MultiTargets.__:new('MultiTargets/TargetWindow'))
            :mockMethod('maybeAllocateItems')
            :mockMethod('setTargetWindowActivePage')
            :mockMethod('renderTargetList')

        local targetList = MultiTargets.__:new('MultiTargets/TargetList', 'test-target-list')

        window:setTargetList(targetList)

        lu.assertEquals(targetList, window.targetList)
        window:getMethod('maybeAllocateItems'):assertCalledOnce()
        window:getMethod('setTargetWindowActivePage'):assertCalledOnce()
        window:getMethod('renderTargetList'):assertCalledOnce()
    end)
    :register()
-- end of TestClassName