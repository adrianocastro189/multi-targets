local command = MultiTargets
    :new('Command')
    :setOperation('clear')
    :setDescription('Clears the current target list')
    :setCallback(function ()
        MultiTargets:invokeOnCurrent('clear')
    end)

MultiTargets.commands:add(command)