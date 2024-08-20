local command = MultiTargets
    :new('Command')
    :setOperation('minimap')
    :setDescription('Pass "show" or "hide" to set the minimap icon visibility')
    :setArgsValidator(function(visibility)
        if visibility ~= 'show' and visibility ~= 'hide' then
            local command = '/multitargets minimap '
            local showCommand = command..MultiTargets.output:color('show')
            local hideCommand = command..MultiTargets.output:color('hide')

            return 'Use '..showCommand..' or '..hideCommand
        end

        return 'valid'
    end)
    :setCallback(function(visibility)
        MultiTargets.minimapIcon:setVisibility(visibility == 'show')
    end)

MultiTargets.commands:add(command)
