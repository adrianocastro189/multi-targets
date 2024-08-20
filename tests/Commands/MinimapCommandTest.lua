TestMinimapCommand = BaseTestClass:new()

-- @covers MinimapCommand.callback
TestCase.new()
    :setName('callback')
    :setTestClass(TestMinimapCommand)
    :setExecution(function(data)
        local command = MultiTargets.commands:getCommandOrDefault('minimap')

        MultiTargets.minimapIcon = Spy
            .new()
            :mockMethod('setVisibility')

        command.callback(data.arg)

        MultiTargets.minimapIcon:getMethod('setVisibility'):assertCalledOnceWith(data.expectedArg)
    end)
    :setScenarios({
        ['hide'] = {
            arg = 'hide',
            expectedArg = false
        },
        ['show'] = {
            arg = 'show',
            expectedArg = true
        },
    })
    :register()

-- @covers MinimapCommand:setArgsValidator()
-- @covers MinimapCommand:validateArgs()
TestCase.new()
    :setName('setArgsValidator')
    :setTestClass(TestMinimapCommand)
    :setExecution(function(data)
        local command = MultiTargets.commands:getCommandOrDefault('minimap')

        local output = command:validateArgs(data.arg)

        lu.assertEquals(data.expectedOutput, output)
    end)
    :setScenarios({
        ['hide'] = {
            arg = 'hide',
            expectedOutput = 'valid'
        },
        ['invalid'] = {
            arg = 'invalid',
            expectedOutput = 'Use /multitargets minimap |cffed5859show|r or /multitargets minimap |cffed5859hide|r'
        },
        ['show'] = {
            arg = 'show',
            expectedOutput = 'valid'
        },
    })
    :register()
