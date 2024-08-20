local command = MultiTargets
    :new('Command')
    :setOperation('remove')
    :setDescription('Removes a target by its name')
    :setCallback(function (name)
        MultiTargets:invokeOnCurrent('remove', name)
    end)

MultiTargets.commands:add(command)