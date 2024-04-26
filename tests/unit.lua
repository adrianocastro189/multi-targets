-- mocks the CreateFrame World of Warcraft API method
-- @TODO: Move this to a separate file <2024.04.25>
CreateFrame = function (...)
    local mockFrame = {
        ['events'] = {},
        ['scripts'] = {},
    }
    
    mockFrame.CreateFontString = function (self, ...) return CreateFrame(...) end
    mockFrame.GetHeight = function (self) return self.height end
    mockFrame.GetWidth = function (self) return self.width end
    mockFrame.Hide = function (self) self.hideInvoked = true end
    mockFrame.EnableMouse = function (self, enable) self.mouseEnabled = enable end
    mockFrame.RegisterEvent = function (self, event) table.insert(self.events, event) end
    mockFrame.SetBackdrop = function (self, backdrop) self.backdrop = backdrop end
    mockFrame.SetBackdropBorderColor = function (self, r, g, b, a) self.backdropBorderColor = { r, g, b, a } end
    mockFrame.SetBackdropColor = function (self, r, g, b, a) self.backdropColor = { r, g, b, a } end
    mockFrame.SetFont = function (self, font, size) self.fontFamily = font self.fontSize = size end
    mockFrame.SetHeight = function (self, height) self.height = height end
    mockFrame.SetHighlightTexture = function (self, texture) self.highlightTexture = texture end
    mockFrame.SetMovable = function (self, movable) self.movable = movable end
    mockFrame.SetNormalTexture = function (self, texture) self.normalTexture = texture end
    mockFrame.SetPoint = function (self, point, relativeFrame, relativePoint, xOfs, yOfs)
        self.points = self.points or {}

        self.points[point] = {
            relativeFrame = relativeFrame,
            relativePoint = relativePoint,
            xOfs = xOfs,
            yOfs = yOfs,
        }
    end
    mockFrame.SetResizable = function (self, resizable) self.resizable = resizable end
    mockFrame.SetScrollChild = function (self, child) self.scrollChild = child end
    mockFrame.SetScript = function (self, script, callback) self.scripts[script] = callback end
    mockFrame.SetSize = function (self, width, height) self.width = width self.height = height end
    mockFrame.SetText = function (self, text) self.text = text end
    mockFrame.SetWidth = function (self, width) self.width = width end
    mockFrame.Show = function (self) self.showInvoked = true end

    return mockFrame
end
-- End

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
        dofile('./src/Views/TargetWindow.lua')
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
dofile('./tests/Views/TargetWindowTest.lua')

os.exit(lu.LuaUnit.run())