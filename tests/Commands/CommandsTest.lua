TestCommands = {}
    -- @covers src/Commands/AddCurrentTargetCommand.lua
    -- @covers src/Commands/ClearTargetListCommand.lua
    function TestCommands:testCommandsWereAdded()
        local operations = MultiTargets.__.commands.operations

        local arr = MultiTargets.__.arr
        lu.assertIsFunction(arr:get(operations, 'addt'))
        lu.assertIsFunction(arr:get(operations, 'clear'))
    end
-- end of TestCommands