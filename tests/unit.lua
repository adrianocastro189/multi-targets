-- mocks the CreateFrame World of Warcraft API method
function CreateFrame(name)
    local mockInstance = {}
    mockInstance.__index = mockInstance
    function mockInstance:RegisterEvent() end
    function mockInstance:SetScript() end
    return mockInstance
end

lu = require('luaunit')

dofile('./lib/stormwind-library.lua')

dofile('./MultiTargets.lua')

dofile('src/Models/Target.lua')
dofile('src/Models/TargetList.lua')

MultiTargets_initializeCore()
lu.assertNotIsNil(MultiTargets)

dofile('tests/Models/TargetTest.lua')
dofile('tests/Models/TargetTestList.lua')

os.exit(lu.LuaUnit.run())