TestMarkerRepository = BaseTestClass:new()
    -- @covers Target.__construct()
    function TestMarkerRepository:testInstantiation()
        local repository = MultiTargets.__:new('MultiTargetsMarkerRepository')

        lu.assertNotIsNil(repository)
        lu.assertIsTrue(MultiTargets.__.arr:isArray(repository.markerPriorities))
    end

    -- @covers MarkerRepository:getMarkIdByTargetIndex()
    function TestMarkerRepository:testGetMarkIdByTargetIndex()
        local repository = MultiTargets.markerRepository

        local function execution(targetIndex, expectedRaidMarker)
            lu.assertEquals(repository:getRaidMarkerByTargetIndex(targetIndex), expectedRaidMarker)
        end

        execution(1,  MultiTargets.__.raidMarkers.skull)
        execution(2,  MultiTargets.__.raidMarkers.x)
        execution(3,  MultiTargets.__.raidMarkers.square)
        execution(4,  MultiTargets.__.raidMarkers.triangle)
        execution(5,  MultiTargets.__.raidMarkers.star)
        execution(6,  MultiTargets.__.raidMarkers.diamond)
        execution(7,  MultiTargets.__.raidMarkers.circle)
        execution(8,  MultiTargets.__.raidMarkers.moon)
        execution(9,  MultiTargets.__.raidMarkers.skull)
        execution(10, MultiTargets.__.raidMarkers.x)
        execution(11, MultiTargets.__.raidMarkers.square)
        execution(12, MultiTargets.__.raidMarkers.triangle)
        execution(13, MultiTargets.__.raidMarkers.star)
        execution(14, MultiTargets.__.raidMarkers.diamond)
        execution(15, MultiTargets.__.raidMarkers.circle)
        execution(16, MultiTargets.__.raidMarkers.moon)
        execution(17, MultiTargets.__.raidMarkers.skull)
    end
-- end of TestMarkerRepository