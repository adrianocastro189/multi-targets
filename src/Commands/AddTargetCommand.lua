local command = MultiTargets
    :new('Command')
    :setOperation('add')
    :setDescription('Adds a target by its name')
    :setCallback(function (name)
        MultiTargets:invokeOnCurrent('add', name)
    end)

MultiTargets.commands:add(command)