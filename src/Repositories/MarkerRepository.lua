--[[
The Marker repository is responsible for determining which markers should be used
for targets based on user settings or on the core addon logic.

In its first version, the markers will be static and users won't be able to change
them, however, in the future, it's expected to have a settings panel where users
can provide rules for determining which markers should be used, which should be
exclusive, and so on.

That said, this repository was created instead of a support class because it
will likely grow in the future and it's better to have a dedicated class for it.
]]
local MarkerRepository = {}
    MarkerRepository.__index = MarkerRepository

    --[[
    MarkerRepository constructor.
    ]]
    function MarkerRepository.__construct()
        local self = setmetatable({}, MarkerRepository)

        self.markerPriorities = {
            MultiTargets.raidMarkers.skull,
            MultiTargets.raidMarkers.x,
            MultiTargets.raidMarkers.square,
            MultiTargets.raidMarkers.triangle,
            MultiTargets.raidMarkers.star,
            MultiTargets.raidMarkers.diamond,
            MultiTargets.raidMarkers.circle,
            MultiTargets.raidMarkers.moon,
        }

        return self
    end

    --[[
    This method works as a way to decide which marker should be used for a target
    based on its index and the current mark priorities defined in this repository.

    As an example, if the target index is 1, the method will return the first
    priority marker, if it's 2, it will return the second priority marker, and so on.
    When the index is bigger than the available priorities, it will return the first
    priority marker again and so on.

    When the target priority can be changed by the user, this method will be updated
    to consider the user's settings instead of the static marker priorities property.

    @treturn RaidMarker
    ]]
    function MarkerRepository:getRaidMarkerByTargetIndex(targetIndex)
        local markerCount = #self.markerPriorities
        local markerIndex = (targetIndex - 1) % markerCount + 1
        return self.markerPriorities[markerIndex]
    end
-- end of MarkerRepository

-- allows this class to be instantiated
MultiTargets:addClass('MultiTargets/MarkerRepository', MarkerRepository)