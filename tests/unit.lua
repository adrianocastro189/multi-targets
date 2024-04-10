-- mocks the CreateFrame World of Warcraft API method
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

lu = require('luaunit')

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

MultiTargets_Data = nil
MultiTargets.__.events:handleOriginal(nil, 'PLAYER_LOGIN')
MultiTargets.__.output:setTestingMode()
lu.assertNotIsNil(MultiTargets)
lu.assertNotIsNil(MultiTargets_Data)
lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.targets'), {})
lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.current'), 0)
lu.assertNotIsNil(MultiTargets.markerRepository)

dofile('./tests/MultiTargetsTest.lua')

dofile('./tests/Commands/CommandsTest.lua')

dofile('./tests/Models/TargetTest.lua')
dofile('./tests/Models/TargetListTest.lua')

dofile('./tests/Repositories/MarkerRepositoryTest.lua')

dofile('./tests/Views/TargetFrameButtonTest.lua')

os.exit(lu.LuaUnit.run())