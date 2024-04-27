local command = MultiTargets.__
    :new('Command')
    :setOperation('hide')
    :setDescription('Hides the target list window')
    :setCallback(function ()
        MultiTargets.targetWindow:setVisibility(false)
    end)

MultiTargets.__.commands:add(command)