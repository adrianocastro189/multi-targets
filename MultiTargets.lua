MultiTargets = {}
MultiTargets.__ = StormwindLibrary_v0_0_6.new()

--[[
Fires up the addon.
]]
function MultiTargets_initializeCore()
    -- initializes the addon data
    if not MultiTargets_Data then MultiTargets_Data = {} end

    MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, 'lists.default.targets', {})
    MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, 'lists.default.current', 0)

    ---------------------------
    -- @TODO: This is temporary
    ---------------------------
    MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
    MultiTargets.currentTargetList:load()
    MultiTargets.rotate = function ()
      MultiTargets.currentTargetList:rotate()
    end
    ---------------------------
end

-- the main event frame used to trigger core initialization
MultiTargetsInitializationFrame = CreateFrame('Frame')

-- registers the PLAYER_LOGIN event
MultiTargetsInitializationFrame:RegisterEvent('PLAYER_LOGIN')

-- fires up the MultiTargets addon when the player logs in
MultiTargetsInitializationFrame:SetScript('OnEvent',
  function(self, event, ...)
    if event == 'PLAYER_LOGIN' then
        MultiTargets_initializeCore()
    end
  end
)