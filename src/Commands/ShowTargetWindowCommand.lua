local command = MultiTargets.__
    :new('Command')
    :setOperation('show')
    :setDescription('Shows the target list window')
    :setCallback(function ()
        MultiTargets.targetWindow:setVisibility(true)
    end)

MultiTargets.__.commands:add(command)