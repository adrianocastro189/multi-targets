TestMarkerRepository = BaseTestClass:new()
    -- @covers Target.__construct()
    function TestMarkerRepository:testInstantiation()
        local repository = MultiTargets:new('MultiTargets/MarkerRepository')

        lu.assertNotIsNil(repository)
        lu.assertIsTrue(MultiTargets.arr:isArray(repository.markerPriorities))
    end

    -- @covers MarkerRepository:getMarkIdByTargetIndex()
    function TestMarkerRepository:testGetMarkIdByTargetIndex()
        local repository = MultiTargets.markerRepository

        local function execution(targetIndex, expectedRaidMarker)
            lu.assertEquals(expectedRaidMarker, repository:getRaidMarkerByTargetIndex(targetIndex))
        end

        execution(1,  MultiTargets.raidMarkers.skull)
        execution(2,  MultiTargets.raidMarkers.x)
        execution(3,  MultiTargets.raidMarkers.square)
        execution(4,  MultiTargets.raidMarkers.triangle)
        execution(5,  MultiTargets.raidMarkers.star)
        execution(6,  MultiTargets.raidMarkers.diamond)
        execution(7,  MultiTargets.raidMarkers.circle)
        execution(8,  MultiTargets.raidMarkers.moon)
        execution(9,  MultiTargets.raidMarkers.skull)
        execution(10, MultiTargets.raidMarkers.x)
        execution(11, MultiTargets.raidMarkers.square)
        execution(12, MultiTargets.raidMarkers.triangle)
        execution(13, MultiTargets.raidMarkers.star)
        execution(14, MultiTargets.raidMarkers.diamond)
        execution(15, MultiTargets.raidMarkers.circle)
        execution(16, MultiTargets.raidMarkers.moon)
        execution(17, MultiTargets.raidMarkers.skull)
    end
-- end of TestMarkerRepository