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

    -- initializes the marker repository singleton
    MultiTargets.markerRepository = MultiTargets.__:new('MultiTargetsMarkerRepository')

    -- initializes the current target list
    -- this will be replaced in the future by a method that loads the
    -- target list from the saved variables, meaning that custom target
    -- lists can be created and loaded
    MultiTargets.currentTargetList = MultiTargets.__:new('MultiTargetsTargetList', 'default')
    MultiTargets.currentTargetList:load()

    -- initializes the target frame button singleton
    MultiTargets.targetFrameButton = MultiTargets.__:new('MultiTargetsTargetFrameButton')

    --[[
    This method serves as a proxy to the loaded target list. It will call
    the method with the given name also passing the given arguments.

    The reason for this method is to avoid having to check if the target
    list is loaded before calling a method on it, otherwise it would be
    necessary to check if the target list is loaded before calling any
    method on it.

    Although the addon was designed to always have a target list loaded,
    it is possible that the target list is not loaded, so this method
    also acts as a sanity check.
    ]]
    function MultiTargets:invokeOnCurrent(methodName, ...)
      local targetList = self.currentTargetList

      if targetList then
        targetList[methodName](targetList, ...)
      end
    end

    --[[
    This method will output the given message to the chat frame.

    It uses the output method from Stormwind Library, which can be easily
    replaced by another method that outputs messages to the chat frame in
    case the addon is used in another context, like a test environment.
    ]]
    function MultiTargets:out(message)
      MultiTargets.__.output:out(message)
    end

    

    ---------------------------
    -- @TODO: This is temporary
    ---------------------------
    
    MultiTargets.print = function ()
      MultiTargets.currentTargetList:print()
    end
    MultiTargets.rotate = function ()
      MultiTargets.currentTargetList:rotate()
    end

    ---------------------------

    
  end
)