local command = MultiTargets.__:new('Command')

command
    :setOperation('clear')
    :setCallback(function ()
        MultiTargets:clear()
    end)

MultiTargets.__.commands:add(command)