function ErrTxt = ListRAPDataFile(RAPStat, Fields, OptFilter, varargin)
%ListRAPDataFile  list the contents of a datafile on the command window
%   ErrTxt = ListRAPDataFile(RAPStat, Fields, OptFilter, SubstVar1, SubsVar2, ...)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 28-05-2004

ErrTxt = '';

%Setting the last error to a meaningful string... This error message 
%appears when user interrupts the output on the command window by
%pressing 'q' on the '--more--' prompt ...
if strcmpi(RAPStat.ComLineParam.More, 'on')
    lasterr('Screen output interrupted by user.'); 
end

if ~isRAPStatDef(RAPStat, 'GenParam.DataFile')
    LUT = getfields(RAPStat.GenParam.LUT, {'iSeq', 'IDstr'});
    LUT = rnfield(LUT, {'iSeq', 'IDstr'}, {'DSnr', 'dsID'});

    %Apply filter if requested ...
    if (nargin >= 3),
        if ischar(OptFilter), %Filter by stimulustype ...
            StimType = lower(OptFilter);
            idx = strfindcell(lower(char(LUT.dsID)), StimType);
            if isempty(idx), ErrTxt = 'No entries found in dataset with requested pattern'; return; end
            LUT = LUT(idx);
        else, %Filter by cellnumber ...
            CellNr = OptFilter;
            CellNrs = char2num(char(LUT.dsID), 1, '-');
            idx = find(CellNrs == CellNr);
            if isempty(idx), ErrTxt = 'Cell number doesn''t exist in datafile'; return; end
            LUT = LUT(idx);
        end
    end
    
    %Assemble extra substitution variables ...
    if (nargin >= 4),
        TempRAPStat = ExecuteRAPCmd(RAPStat, NaN, 'sync', 'off'); %No synchronization ...
        NElem = length(LUT); NVar = length(varargin); Values = cell(NElem, NVar);
        for ElemNr = 1:NElem,
            [TempRAPStat, dummy, ErrTxt] = ExecuteRAPCmd(TempRAPStat, NaN, 'ds', LUT(ElemNr).DSnr);
            if ~isempty(ErrTxt), return; end
            for VarNr = 1:NVar,
                try, 
                    [dummy, Val] = EvalRAPSubstVar(TempRAPStat, varargin{VarNr});
                    if isempty(Val), error('To catch block ...'); end
                    Values{ElemNr, VarNr} = mat2str(Val);
                catch, Values{ElemNr, VarNr} = 'N/A'; end
            end    
        end 
        Str1 = cv2str(getfields(LUT, Fields)); Str1(:, end) = [];
        Str2 = cv2str([varargin; Values]);
        disp([Str1 Str2]);
    else, disp(cv2str(getfields(LUT, Fields))); end
else
    ErrTxt = 'Datafile not yet specified'; 
    return; 
end