TestCommands = BaseTestClass:new()
    -- @covers src/Commands/AddCurrentTargetCommand.lua
    -- @covers src/Commands/ClearTargetListCommand.lua
    function TestCommands:testCommandsWereAdded()
        local operations = MultiTargets.__.commands.operations

        local arr = MultiTargets.__.arr
        lu.assertNotIsNil(arr:get(operations, 'add'))
        lu.assertNotIsNil(arr:get(operations, 'addt'))
        lu.assertNotIsNil(arr:get(operations, 'clear'))
        lu.assertNotIsNil(arr:get(operations, 'hide'))
        lu.assertNotIsNil(arr:get(operations, 'print'))
        lu.assertNotIsNil(arr:get(operations, 'remove'))
        lu.assertNotIsNil(arr:get(operations, 'removet'))
        lu.assertNotIsNil(arr:get(operations, 'show'))
    end
-- end of TestCommands