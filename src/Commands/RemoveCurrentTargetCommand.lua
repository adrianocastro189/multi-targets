local command = MultiTargets.__
    :new('Command')
    :setOperation('removet')
    :setDescription('Removes the current target from the target list')
    :setCallback(function ()
        MultiTargets:invokeOnCurrent('removeTargetted')
    end)

MultiTargets.__.commands:add(command)