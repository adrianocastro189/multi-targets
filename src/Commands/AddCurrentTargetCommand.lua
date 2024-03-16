local command = MultiTargets.__:new('Command')

command
    :setOperation('addt')
    :setCallback(function ()
        MultiTargets:addTargetted()
    end)

MultiTargets.__.commands:add(command)