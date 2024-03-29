local command = MultiTargets.__
    :new('Command')
    :setOperation('add')
    :setDescription('Adds a target by its name')
    :setCallback(function (name)
        MultiTargets:invokeOnCurrent('add', name)
    end)

MultiTargets.__.commands:add(command)