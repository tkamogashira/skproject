%Checks particulars of the device and circuit

RP = Circuit_Loader; % Runs Circuit_Loader.

if invoke(RP,'GetStatus')==7
    
    Cycle_Usage=invoke(RP,'GetCycUse'); % Checks cycle usage
    disp(['Cycle usage = ' num2str(Cycle_Usage) '%']);
    
    if Cycle_Usage > 90
        disp('Warning RP at upper limit of Cycle Usage');
    end
    
    % Gets the number of each of the component types: 
    % Component, Parameter Table, Source File, Parameter Tag
    NumComponents=double(invoke(RP,'GetNumOf','Component'));
    NumParTables=double(invoke(RP,'GetNumOf','ParTable'));
    NumSrcFiles=double(invoke(RP,'GetNumof','SrcFile'));
    NumParTags=double(invoke(RP,'GetNumof','ParTag'));

    % Gets the names of each of the Components (String ID) 
    % returns NoName if user does not name component
    disp('Components: ');
    for z=1:NumComponents
        disp(['   ' invoke(RP,'GetNameOf','Component',z)]);
    end

    %Gets the names of each of the Data Tables (if any)
    if NumParTables > 0 
        disp('Data Tables: ');
    end
    for z=1:NumParTables
        disp(['   ' invoke(RP,'GetNameOf','ParTable',z)]);
    end

    %Gets the names of the Data Files (if any)
    if NumSrcFiles > 0
        disp('Data Files: ');
    end
    for z=1:NumSrcFiles
        disp(['   ' invoke(RP,'GetNameOf','SrcFile',z)]);
    end

    %Gets the names of the Parameter Tags, The TagType (data type), and TagSize
    disp('Parameter Tags: ');
    for z=1:NumParTags
        PName = invoke(RP,'GetNameOf','ParTag',z); % Returns the Parameter name
        PType = char(invoke(RP,'GetTagType',PName)); % Returns the Tag Type: Single, Integer, Data, Logical
        PSize = invoke(RP,'GetTagSize',PName); % Returns TagSize (size of Data Buffer or 1)
        disp(['   ' PName '   type ' PType '  size ' num2str(PSize)]);
    end
    invoke(RP, 'Halt');
end
