function ListRAPMem(RAPStat)
%ListRAPMem  lists RAP memory
%   ListRAPMem(RAPStat) lists the RAP memory on the MATLAB command
%   window.
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 06-02-2004

%Setting the last error to a meaningful string... This error message 
%appears when user interrupts the output on the command window by
%pressing 'q' on the '--more--' prompt ...
if strcmpi(RAPStat.ComLineParam.More, 'on'), lasterr('Screen output interrupted by user.'); end

%Reorganizing memory information ...
Memory = RAPStat.Memory;

idx = find(~cellfun('isempty', Memory.V));
if isempty(idx), MemVStr = '';
else, 
    NElem = length(idx);
    Sep = repmat({' : '}, 1, NElem);
    EndSep = repmat({char(13)}, 1, NElem);
    MemVStr = cv2str(vectorzip(num2cell(idx), Sep, Memory.V(idx), EndSep)); 
end    

idx = find(~cellfun('isempty', Memory.C));
if isempty(idx), MemCStr = '';
else,
    NElem = length(idx);
    Sep = repmat({' : '}, 1, NElem);
    EndSep = repmat({char(13)}, 1, NElem);
    MemCStr = cv2str(vectorzip(num2cell(idx), Sep, Memory.C(idx), EndSep)); 
end    

%Displaying information ...
if isempty(MemVStr) & isempty(MemCStr),
    fprintf('No memory variables defined.\n');
else,    
    fprintf('Memory variables\n');
    fprintf('----------------\n');
    if ~isempty(MemVStr),
        fprintf('   *numeric variables*\n');
        disp(MemVStr);
    end
    if ~isempty(MemCStr),
        fprintf('   *character variables*\n');
        disp(MemCStr);
    end
end