TestMacro = BaseTestClass:new()
    -- @covers Macro.__construct()
    function TestMacro:testConstructor()
        local macro = MultiTargets.__:new('MultiTargetsMacro')

        lu.assertNotIsNil(macro)
        -- make sure Macro inherits from the Stormwind Library Macro model
        lu.assertIsFunction(macro.setBody)
    end

    -- @covers Macro:updateMacro()
    function TestMacro:testUpdateMacro()
        local macro = MultiTargets.__:new('MultiTargetsMacro')

        macro.save = function() self.saveInvoked = true end

        lu.assertIsNil(macro.body)
        lu.assertIsNil(self.saveInvoked)

        macro:updateMacro('test-body')

        lu.assertEquals('test-body', macro.body)
        lu.assertTrue(self.saveInvoked)
    end
-- end of TestMacro