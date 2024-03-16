local command = MultiTargets.__
    :new('Command')
    :setOperation('addt')
    :setCallback(function ()
        MultiTargets:addTargetted()
    end)

MultiTargets.__.commands:add(command)