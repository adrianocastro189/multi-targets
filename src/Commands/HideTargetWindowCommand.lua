local command = MultiTargets
    :new('Command')
    :setOperation('hide')
    :setDescription('Hides the target list window')
    :setCallback(function ()
        MultiTargets.targetWindow:setVisibility(false)
    end)

MultiTargets.commands:add(command)