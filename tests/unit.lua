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

MultiTargets_Data = nil
MultiTargets_initializeCore()
lu.assertNotIsNil(MultiTargets)
lu.assertNotIsNil(MultiTargets_Data)
lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.targets'), {})
lu.assertEquals(MultiTargets.__.arr:get(MultiTargets_Data, 'lists.default.current'), 0)

dofile('tests/Models/TargetTest.lua')
dofile('tests/Models/TargetListTest.lua')

os.exit(lu.LuaUnit.run())