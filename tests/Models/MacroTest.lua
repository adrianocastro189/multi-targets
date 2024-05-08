TestMacro = BaseTestClass:new()
    -- @covers Macro.__construct()
    function TestMacro:testConstructor()
        local macro = MultiTargets.__:new('MultiTargetsMacro')

        lu.assertNotIsNil(macro)
        -- make sure Macro inherits from the Stormwind Library Macro model
        lu.assertIsFunction(macro.setBody)
    end
-- end of TestMacro