local command = MultiTargets.__
    :new('Command')
    :setOperation('addt')
    :setDescription('Adds the current target to the target list')
    :setCallback(function ()
        MultiTargets:addTargetted()
    end)

MultiTargets.__.commands:add(command)