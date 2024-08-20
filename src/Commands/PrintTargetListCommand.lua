local command = MultiTargets
    :new('Command')
    :setOperation('print')
    :setDescription('Prints the current target list')
    :setCallback(function ()
        MultiTargets:invokeOnCurrent('print')
    end)

MultiTargets.commands:add(command)