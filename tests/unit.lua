-- mocks the CreateFrame World of Warcraft API method
-- @TODO: Move this to a separate file <2024.04.25>
function CreateFrame(name)
    local mockInstance = {}
    mockInstance.__index = mockInstance
    function mockInstance:RegisterEvent() end
    function mockInstance:SetPoint() end
    function mockInstance:SetScript() end
    function mockInstance:SetSize() end
    function mockInstance:SetText() end
    return mockInstance
end

SlashCmdList = {}
UnitName = function() return 'test-unit-name' end

lu = require('luaunit')

--[[
This is a base test class that sets up the addon table before each test.

Every test class should inherit from this class to have the addon set up
before each test. That way, mocking the addon methods and properties on tests
won't affect the results of other tests.

The setUp() method is expected to be called before each test.
]]
BaseTestClass = {
    new = function(self)
        local instance = {}
        setmetatable(instance, self)
        self.__index = self
        return instance
    end,
    
    setUp = function()
        dofile('./lib/stormwind-library.lua')

        dofile('./MultiTargets.lua')
        dofile('./src/Commands/AddCurrentTargetCommand.lua')
        dofile('./src/Commands/AddTargetCommand.lua')
        dofile('./src/Commands/ClearTargetListCommand.lua')
        dofile('./src/Commands/PrintTargetListCommand.lua')
        dofile('./src/Commands/RemoveCurrentTargetCommand.lua')
        dofile('./src/Commands/RemoveTargetCommand.lua')
        dofile('./src/Models/Target.lua')
        dofile('./src/Models/TargetList.lua')
        dofile('./src/Repositories/MarkerRepository.lua')
        dofile('./src/Views/TargetFrameButton.lua')
        dofile('./src/Views/TargetWindowItem.lua')

        MultiTargets_Data = nil
        MultiTargets.__.events:handleOriginal(nil, 'PLAYER_LOGIN')
        MultiTargets.__.output:setTestingMode()

        function dd(...) MultiTargets.__.output:dd(...) end
    end,

    -- guarantees that every test class inherits from this class by forcing
    -- the global addon usages to throw an error if it's not set, so tests
    -- that miss inheriting from this class will fail
    tearDown = function()
        MultiTargets = nil
    end,
}

dofile('./tests/MultiTargetsTest.lua')
dofile('./tests/Commands/CommandsTest.lua')
dofile('./tests/Models/TargetTest.lua')
dofile('./tests/Models/TargetListTest.lua')
dofile('./tests/Repositories/MarkerRepositoryTest.lua')
dofile('./tests/Views/TargetFrameButtonTest.lua')
dofile('./tests/Views/TargetWindowItemTest.lua')

os.exit(lu.LuaUnit.run())