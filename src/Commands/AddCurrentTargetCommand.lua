local command = MultiTargets
    :new('Command')
    :setOperation('addt')
    :setDescription('Adds the current target to the target list')
    :setCallback(function ()
        MultiTargets:invokeOnCurrent('addTargetted')
    end)

MultiTargets.commands:add(command)