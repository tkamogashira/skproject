%Checks particulars of the device and circuit

RP = Circuit_Loader; % Runs Circuit_Loader.

if RP.GetStatus==7
    
    Cycle_Usage=invoke(RP,'GetCycUse'); % Checks cycle usage
    disp(['Cycle usage = ' num2str(Cycle_Usage) '%']);
    
    if Cycle_Usage > 90
        disp('Warning RP at upper limit of Cycle Usage');
    end
    
    % Gets the number of each of the component types: 
    % Component, Parameter Table, Source File, Parameter Tag
    NumComponents=double(RP.GetNumOf('Component'));
    NumParTables=double(RP.GetNumOf('ParTable'));
    NumSrcFiles=double(RP.GetNumOf('SrcFile'));
    NumParTags=double(RP.GetNumOf('ParTag'));

    % Gets the names of each of the Components (String ID) 
    % returns NoName if user does not name component
    disp('Components: ');
    for z=1:NumComponents
        disp(['   ' RP.GetNameOf('Component',z)]);
    end

    %Gets the names of each of the Data Tables (if any)
    if NumParTables > 0 
        disp('Data Tables: ');
    end
    for z=1:NumParTables
        disp(['   ' RP.GetNameOf('ParTable',z)]);
    end

    %Gets the names of the Data Files (if any)
    if NumSrcFiles > 0
        disp('Data Files: ');
    end
    for z=1:NumSrcFiles
        disp(['   ' RP.GetNameOf('SrcFile',z)]);
    end

    %Gets the names of the Parameter Tags, The TagType (data type), and TagSize
    disp('Parameter Tags: ');
    for z=1:NumParTags
        PName = RP.GetNameOf('ParTag',z); % Returns the Parameter name
        PType = char(RP.GetTagType(PName)); % Returns the Tag Type: Single, Integer, Data, Logical
        PSize = RP.GetTagSize(PName); % Returns TagSize (size of Data Buffer or 1)
        disp(['   ' PName '   type ' PType '  size ' num2str(PSize)]);
    end
    RP.Halt;
end
