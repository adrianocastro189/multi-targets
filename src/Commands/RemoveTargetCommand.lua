local command = MultiTargets.__
    :new('Command')
    :setOperation('remove')
    :setDescription('Removes a target by its name')
    :setCallback(function (name)
        MultiTargets:invokeOnCurrent('remove', name)
    end)

MultiTargets.__.commands:add(command)