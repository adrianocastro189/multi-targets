local command = MultiTargets
    :new('Command')
    :setOperation('show')
    :setDescription('Shows the target list window')
    :setCallback(function ()
        MultiTargets.targetWindow:setVisibility(true)
    end)

MultiTargets.commands:add(command)