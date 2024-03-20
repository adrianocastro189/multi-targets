local command = MultiTargets.__
    :new('Command')
    :setOperation('clear')
    :setDescription('Clears the current target list')
    :setCallback(function ()
        MultiTargets:clear()
    end)

MultiTargets.__.commands:add(command)