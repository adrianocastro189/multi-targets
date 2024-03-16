TestMarkerRepository = {}
    -- @covers Target.__construct()
    function TestMarkerRepository:testInstantiation()
        local repository = MultiTargets.__:new('MultiTargetsMarkerRepository')

        lu.assertNotIsNil(repository)
        lu.assertIsTrue(MultiTargets.__.arr:isArray(repository.markerPriorities))
    end

    -- @covers MarkerRepository:getMarkIdByTargetIndex()
    function TestMarkerRepository:testGetMarkIdByTargetIndex()
        local repository = MultiTargets.markerRepository

        local function execution(targetIndex, expectedMarkId)
            lu.assertEquals(repository:getMarkIdByTargetIndex(targetIndex), expectedMarkId)
        end

        execution(1, MultiTargets.__.target.MARKER_SKULL)
        execution(2, MultiTargets.__.target.MARKER_X)
        execution(3, MultiTargets.__.target.MARKER_SQUARE)
        execution(4, MultiTargets.__.target.MARKER_TRIANGLE)
        execution(5, MultiTargets.__.target.MARKER_STAR)
        execution(6, MultiTargets.__.target.MARKER_DIAMOND)
        execution(7, MultiTargets.__.target.MARKER_CIRCLE)
        execution(8, MultiTargets.__.target.MARKER_MOON)
        execution(9, MultiTargets.__.target.MARKER_SKULL)
        execution(10, MultiTargets.__.target.MARKER_X)
        execution(11, MultiTargets.__.target.MARKER_SQUARE)
        execution(12, MultiTargets.__.target.MARKER_TRIANGLE)
        execution(13, MultiTargets.__.target.MARKER_STAR)
        execution(14, MultiTargets.__.target.MARKER_DIAMOND)
        execution(15, MultiTargets.__.target.MARKER_CIRCLE)
        execution(16, MultiTargets.__.target.MARKER_MOON)
        execution(17, MultiTargets.__.target.MARKER_SKULL)
    end
-- end of TestMarkerRepository