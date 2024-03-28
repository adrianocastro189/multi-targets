local __ = StormwindLibrary_v0_0_7.new({
  colors = {
    primary = 'ED5859'
  },
  command = 'multitargets',
  name = 'MultiTargets'
})

MultiTargets = {}
MultiTargets.__ = __

local events = __.events

events:listen(events.EVENT_NAME_PLAYER_LOGIN, function ()
    -- initializes the addon data
    if not MultiTargets_Data then MultiTargets_Data = {} end

    MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, 'lists.default.targets', {})
    MultiTargets.__.arr:maybeInitialize(MultiTargets_Data, 'lists.default.current', 0)

    MultiTargets.markerRepository = MultiTargets.__:new('MultiTargetsMarkerRepository')

    ---------------------------
    -- @TODO: This is temporary
    ---------------------------
    function MultiTargets:out(message)
      MultiTargets.__.output:out(message)
    end
    MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
    MultiTargets.currentTargetList:load()
    function MultiTargets:add(name)
      MultiTargets.currentTargetList:add(name)
    end
    function MultiTargets:remove(name)
      MultiTargets.currentTargetList:remove(name)
    end
    MultiTargets.addTargetted = function ()
      MultiTargets.currentTargetList:addTargetted()
    end
    function MultiTargets:removeTargetted ()
      MultiTargets.currentTargetList:removeTargetted()
    end
    MultiTargets.clear = function ()
      MultiTargets.currentTargetList:clear()
    end
    MultiTargets.maybeMark = function ()
      MultiTargets.currentTargetList:maybeMark()
    end
    MultiTargets.print = function ()
      MultiTargets.currentTargetList:print()
    end
    MultiTargets.rotate = function ()
      MultiTargets.currentTargetList:rotate()
    end

    ---------------------------

    MultiTargets.targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')
  end
)