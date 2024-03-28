local command = MultiTargets.__
    :new('Command')
    :setOperation('add')
    :setDescription('Adds a target by name')
    :setCallback(function (name)
        MultiTargets:add(name)
    end)

MultiTargets.__.commands:add(command)