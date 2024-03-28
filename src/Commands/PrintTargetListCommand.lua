local command = MultiTargets.__
    :new('Command')
    :setOperation('print')
    :setDescription('Prints the current target list')
    :setCallback(function ()
        MultiTargets:invokeOnCurrent('print')
    end)

MultiTargets.__.commands:add(command)