function dspblkcopystw(blockh)

% Copyright 2004-2010 The MathWorks, Inc.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The purpose of this mask function is to control the variable name
% during block copy of the Signal To Workspace block.
% Based on the observation of Simulink To Workspace block's behavior:
% --  Don't rearrange the variable name if the block is in a subsystem, 
%     even though the search will include blocks in subsystems(bdroot).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmp(bdroot(gcs), gcs)
    obj = get_param(blockh,'object');
    
    if strcmp(obj.BlockType, 'SignalToWorkspace')
        stws = true;
    else % Triggered To Workspace subsystem
        stws = false;
    end
        
    
    %-- Get variable name
    if stws
        varName = get_param(blockh, 'VariableName');
    else
        vals = obj.MaskValues;
        idx = strmatch('VariableName',obj.MaskNames);
        varName = vals{idx};
    end
    
    %-- Extract digit number from variable name
    % double('0') = 48; double('9')=57;
    dVar = double(varName);
    h = and(dVar>=48,dVar<=57);
    if find(h==0, 1, 'last') == length(h)
        myName = varName;
    else
        myName = varName(1:find(h==0, 1, 'last'));
    end
    
    % Prepare for mask Values settings
    % Set it to something else first
    if stws
        val = [myName num2str(inf)];
        set_param(blockh, 'VariableName', val);
    else
        vals{idx} = [myName num2str(inf)];
        obj.MaskValues = vals;
    end
    
    %-- Look for variable name suffix of the same mask type
    %-- consider 3 kinds of blocks: Type, Type2, Type3
    %-- This makes Signal To Workspace behave better than Simulink To
    %   Workspace block
    %-- When re-arrange variable name, consider all block in the model root
    %   (the search will include blocks under subsystems -- use bdroot)
    Type1 = 'SignalToWorkspace';
    Type2 = 'Triggered To Workspace';
    Type3 = 'ToWorkspace';
    a1Var = find_system(bdroot(gcs), 'LookUnderMasks', 'all', 'BlockType', Type1);
    a2Var = find_system(bdroot(gcs), 'LookUnderMasks', 'all', 'MaskType', Type2);
    a3Var = find_system(bdroot(gcs), 'LookUnderMasks', 'all', 'BlockType',Type3);
    blkName = [get_param(a1Var, 'variableName');...
        get_param(a2Var, 'variableName');...
        get_param(a3Var, 'variableName')];   
    
    % Because sort() can't sort a cell array in the way we want,
    % Extract numeric number from each variable name to sort
    L        = length(blkName);
    nameVar  = cell(L,1);
    indexVar = zeros(L,1);
    for i=1:L
        ithName = blkName{i};
        iVar = double(ithName);
        %-- Extract digit number from variable name
        h = and(iVar>=48,iVar<=57);
        %-- separate the last numeric numbers from the variable name
        if (find(h==0, 1, 'last') == length(h))
            nameVar{i} = ithName;
            % indexVar was initiated as zero
        else
            nameVar{i} = ithName(1:find(h==0, 1, 'last'));
            indexVar(i) = str2double(ithName(find(h==0, 1, 'last')+1:end));
        end
    end
    % sort with numeric numbers
    [~, index] = sort(indexVar);
    indexSort  = indexVar(index);
    nameSort   = nameVar(index);
    
    % Now the variable names are properly sorted
    % Find the minimum index number that can be used
    minIndex  = 0;
    for i=1:L
        % If found the same variable name, compare the suffix and keep the
        % smallest
        if strcmp(nameSort{i},myName)
            if minIndex == indexSort(i)
                minIndex = indexSort(i) +1;
            end
        end
    end
    
    %-- convert to string except for 0
    if minIndex > 0
        minIndex = num2str(minIndex);
    end
    
    if stws
        %-- Attach index
        val = [myName minIndex];
        %-- Set new name
        set_param(blockh, 'VariableName', val);
    else
        %-- Attach index
        vals{idx} = [myName minIndex];

        %Restore mask Values settings
        obj.MaskValues = vals;
    end
    
end
