function List = genCorrList(varargin)
%GENCORRLIST  generate list for creation of correlograms.
%   List = genCorrList(List, FileName, iSeqs/SeqIDs, iSubSeqs/IndepVals) adds
%   rows to the supplied structure-array List that contains information on
%   the localization of responses of a fiber/cell to positive and negative
%   noise tokens. Sequences of a datafile can be supplied by number or by
%   identifier, subsequences of a dataset by value of the independent 
%   variable or by subsequence number (see property 'subseqinput'). Filename
%   and sequence identifiers can be supplied as character string or cell-array,
%   sequence and subsequence numbers and values of the independent variable
%   must be supplied as numeric matrices. Rows specify different fibers/cells,
%   while columns specify different responses (the left column contains
%   localizations on responses to the positive noise token and the right
%   column on responses to the negative noise token). Duplicates need not
%   be specified.
%
%   An example with genCorrList (see kevCorr for a real life
%   example):
%       List = genCorrList(struct([]), 'A0242', [-140, -141], (40:10:80)', ...
%           'discernvalue', ['subsref(getfield(dataset($filename$, $iseqp$), ', ...
%           '''indepval''), struct(''type'', ''()'', ''subs'', {{$isubseqp$}}))']);
%       GenWFPlot(List, 3, 'discernfieldlabel', 'Intensity', ...
%           'discernfieldunit', 'dB SPL');
%       
%       List = genCorrList(struct([]), 'A0307', [368; 666; 486; 748], [+1, -1]);
%       GenWFPlot(List, 2, 'discernfieldlabel', 'Frequency', ...
%           'discernfieldunit', 'Hz', 'rightyexpr', 'greenwood($discernvalue$)', ...
%           'rightylabel', 'Distance', 'rightyunit', 'mm');
%
%       List = genCorrList(struct([]), 'A0242', 341, [+1, -1], ... 
%           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
%       List = genCorrList(List, 'A0242', [336; 337], [+1, -1], ... 
%           'discernvalue', 'getfield(dataset($filename$, $iseqp$), ''spl'')');
%       GenWFPlot(List, 1, 'cortype', 'across', 'refautocor', 'no', ...
%           'discernfieldlabel', 'Intensity', 'discernfieldunit', 'dB SPL');
%
%   Optional properties and their values can be given as a comma-separated
%   list. To view list of all possible properties and their default value, 
%   use 'factory' as only input argument. See relevant code-section for an
%   explanation on the meaning of the different properties.

%B. Van de Sande 10-08-2005


%--------------------properties and their default values---------------------
%The property 'subseqinput' determines whether the subsequences of datasets
%are specified by the value of the independent variable ('indepval') or by 
%number ('subseq').
DefProps.subseqinput = 'indepval'; %'indepval' or 'subseq' ...
%The property 'discernvalue' determines the value that is used to distinguish
%each fiber/cell in the resulting structure-array from all other fibers/cells.
%It can be supplied as an expression on the rows of the resulting structure-
%array (except the fieldname 'discernvalue' cannot be refered to). If a cell-
%array of strings with expressions is supplied then for a given fiber/cell
%expressions are evaluated until one results in a non-nan number.
%These values can also be given as a numeric scalar or vector. The vector have
%the same number of elements as the number of rows in the resulting structure-
%array. By default the tuning frequency of a fiber/cell is used as the 
%distinguishing value. This frequency is determined based on the dominant 
%frequency of the difcor. If this results in a NaN, then the dominant frequency
%of the autocorrelogram is used. And finally the characteristic frequency from
%the threshold curve is taken.
DefProps.discernvalue = { ...
    ['structfield(EvalSACXAC(dataset($filename$, $iseqp$), $isubseqp$, ', ...
     'dataset($filename$, $iseqn$), $isubseqn$, ''plot'', ''no'', ''subseqinput'', ', ...
     '''subseq''), ''diff.fft.df'')'], ...
    ['structfield(EvalSACXAC(dataset($filename$, $iseqp$), $isubseqp$, ', ...
     'dataset($filename$, $iseqn$), $isubseqn$, ''plot'', ''no'', ''subseqinput'', ', ...
     '''subseq''), ''ac.fft.df'')'], ...
    ['mean([structfield(EvalTHR(dataset($filename$, structfield(getuserdata(', ...
     'dataset($filename$, $iseqp$)), ''CellInfo.THRSeq'')), ''plot'', ''no''), ', ...
     '''thr.cf''), structfield(EvalTHR(dataset($filename$, structfield(', ...
     'getuserdata(dataset($filename$, $iseqn$)), ''CellInfo.THRSeq'')), ''plot'', ', ...
     '''no''), ''thr.cf'')])']};

%--------------------template for row of returned structure-array------------
%The fields that are present in the returned structure-array and that fully
%localize the responses of a fiber/cell to a positive and/or negative noise
%token.

Template.filename     = '';  %The name of the datafile that contains the
                             %datasets with the responses to the positive and/or
                             %negative noise tokens.
Template.iseqp        = NaN; %The sequence number that contains the responses
                             %to the positive noise token.
Template.isubseqp     = NaN; %The subsequence number that contains the responses
                             %to the positive noise token.
Template.iseqn        = NaN; %The sequence number that contains the responses
                             %to the negative noise token .
Template.isubseqn     = NaN; %The subsequence number that contains the responses
                             %to the positive noise token.
Template.discernvalue = NaN; %The value that is used to distinguish this fiber/
                             %cell from all other fibers/cells in the structure
                             %array.

%--------------------------------main program--------------------------------
%Evaluate input arguments ...
if (nargin == 1) & ischar(varargin{1}) & strcmpi(varargin{1}, 'factory'),
    disp('Properties and their factory defaults:'); 
    disp(DefProps);
    return;
else, 
    [List, FileNames, iSeqs, iSubSeqs, Props] = ParseArgs(DefProps, ...
        Template, varargin{:}); 
end

%Calculate values for the field 'discernvalue' ...
Data = [FileNames(:, 1), num2cell(iSeqs), num2cell(iSubSeqs)];
Data = Data(:, [1 2 4 3 5]);
if isnumeric(Props.discernvalue), DiscernValues = Props.discernvalue;
else,    
    NElem = size(Data, 1); DiscernValues = repmat(NaN, NElem, 1);
    NExpr = length(Props.discernvalue);
    for n = 1:NElem,
        CurValue = NaN; ExprNr = 1;
        while isnan(CurValue) & (ExprNr <= NExpr),
            CurValue = evalexpr(Props.discernvalue{ExprNr}, Data(n, :));
        end
        DiscernValues(n) = CurValue;
    end
end
FieldNames = structfieldnames(Template);
Data = [Data, num2cell(DiscernValues)];

%Assemble list ...
if ~isempty(List)
    List = [List(:); construct(Data, FieldNames)];
else
    List = construct(Data, FieldNames);
end

%-------------------------------local functions------------------------------
function [List, FileNames, iSeqs, iSubSeqs, Props] = ParseArgs(DefProps, Template, varargin)

NArgs = length(varargin); 
if (NArgs < 4), error('Wrong number of input arguments.'); end
NEntries = max(cellfun('size', varargin(1:4), 1));

%Check properties and their values ...
Props = checkproplist(DefProps, varargin{5:end});
Props = CheckAndTransformProps(Props, Template, NEntries);

%Checking mandatory arguments ...
List = CheckAndTransformList(varargin{1}, Template);
FileNames = CheckAndTransformFileNames(varargin{2}, NEntries);
if ~isequal(FileNames(:, 1), FileNames(:, 2)),
    error(['Responses to positive and negative noise token should be part ', ...
            'of same experiment.']);
end
iSeqs = CheckAndTransformiSeqs(varargin{3}, FileNames, NEntries);
iSubSeqs = CheckAndTransformiSubSeqs(varargin{4}, FileNames, iSeqs, NEntries, Props);

%----------------------------------------------------------------------------
function Props = CheckAndTransformProps(Props, Template, NEntries)

if ~ischar(Props.subseqinput) | ~any(strcmpi(Props.subseqinput, {'indepval', 'subseq'})),
    error('Property ''subseqinput'' must be ''indepval'' or ''subseq''.');
end

AllowedFNames = structfieldnames(Template);
AllowedFNames(find(strcmpi(AllowedFNames, 'discernvalue'))) = [];
try,
    if ischar(Props.discernvalue),
        Props.discernvalue = {parseExpr(Props.discernvalue, AllowedFNames)};
    elseif iscellstr(Props.discernvalue),
        NExpr = length(Props.discernvalue);
        for n = 1:NExpr,
            Props.discernvalue{n} = ParseExpr(Props.discernvalue{n}, AllowedFNames);
        end
    elseif isnumeric(Props.discernvalue) & any(numel(Props.discernvalue) == [1, NEntries]),
        Props.discernvalue = repmat(Props.discernvalue(:), ...
            NEntries-numel(Props.discernvalue)+1, 1);
    else, error('To catch block ...'); end
catch, 
    error(sprintf(['Property ''discernvalue'' must be numeric scalar, numeric vector with the same number of\n', ...
                   'elements as entries in the list or a character string or cell-array of strings with valid\n', ...
                   'expressions.'])); 
end

%----------------------------------------------------------------------------
function List = CheckAndTransformList(List, Template)

try,
    if ~isstruct(List), error('To catch block ...'); end
    if ~isempty(List) & ~isequal(structfieldnames(List), structfieldnames(Template)),
        error('To catch block ...');
    end
catch, error('First argument should be valid structure-array.'); end

%----------------------------------------------------------------------------
function FileNames = CheckAndTransformFileNames(FileNames, NEntries)

if ischar(FileNames), FileNames = repmat({FileNames}, NEntries, 2); 
elseif iscellstr(FileNames) & any(size(FileNames, 2) == [1, 2]) & ...
        any(size(FileNames, 1) == [1, NEntries]),
    FileNames = repmat(FileNames, NEntries-size(FileNames, 1)+1, 2-size(FileNames, 2)+1);
else, error('Datafile must be specified by their filename.'); end

%----------------------------------------------------------------------------
function iSeqs = CheckAndTransformiSeqs(InputArg, FileNames, NEntries)

if ischar(InputArg), 
    iSeqs = GetiSeq4SeqID(FileNames, repmat({InputArg}, NEntries, 2));
elseif iscellstr(InputArg) & any(size(InputArg, 2) == [1, 2]) & ...
        any(size(InputArg, 1) == [1, NEntries]),
    iSeqs = GetiSeq4SeqID(FileNames, repmat(InputArg(:), ...
        NEntries-size(InputArg, 1)+1, 2-size(InputArg, 2)+1));
elseif isnumeric(InputArg) & any(size(InputArg, 2) == [1, 2]) & ...
        any(size(InputArg, 1) == [1, NEntries]),
    iSeqs = repmat(InputArg, NEntries-size(InputArg, 1)+1, 2-size(InputArg, 2)+1);
else, 
    error('Sequences of a datafile must be specified by identifier or number.'); 
end

if any(isnan(iSeqs)), error('One of the given sequences doesn''t exist.'); end

%----------------------------------------------------------------------------
function iSeq = GetiSeq4SeqID(FileName, SeqID)

if iscellstr(FileName) | iscellstr(SeqID),
    [FileName, SeqID] = deal(cellstr(FileName), cellstr(SeqID));
    Sz = [max([size(FileName, 1), size(SeqID, 1)]), ...
            max([size(FileName, 2), size(SeqID, 2)])];
    Nrec = max([numel(FileName), numel(SeqID)]);
    FileName = repmat(FileName(:), Nrec-numel(FileName)+1, 1);
    SeqID = repmat(SeqID(:), Nrec-numel(iSeq)+1, 1);
    iSeq = zeros(Nrec, 1); %Pre-allocation ...
    for n = 1:Nrec, iSeq(n) = GetiSeq4SeqID(FileName{n}, SeqID(n)); end %Recursion ...   
    iSeq = reshape(iSeq, Sz);
else,
    try,
        LUT = log2lut(FileName);
        idx = strmatch(SeqID, char(LUT.IDstr));
        if (prod(size(idx)) ~= 1), error('To catch block ...'); end
        iSeq = LUT(idx).iSeq;
    catch, iSeq = NaN; end
end

%----------------------------------------------------------------------------
function iSubSeqs = CheckAndTransformiSubSeqs(InputArg, FileNames, iSeqs, ...
    NEntries, Props)

if isnumeric(InputArg) & any(size(InputArg, 2) == [1, 2]) & ...
        any(size(InputArg, 1) == [1, NEntries]),
    InputArg = repmat(InputArg, NEntries-size(InputArg, 1)+1, 2-size(InputArg, 2)+1);
else, 
    error(['Subsequences of a datafile must be specified by value of the independent ', ...
            'variable or by number.']); 
end

if strcmpi(Props.subseqinput, 'indepval'),
    iSubSeqs = GetiSubSeq4IndepVal(FileNames, iSeqs, InputArg);
else, iSubSeqs = InputArg; end

if any(isnan(iSubSeqs)), error('One of the given subsequences doesn''t exist.'); end

%----------------------------------------------------------------------------
function iSubSeq = GetiSubSeq4IndepVal(FileName, iSeq, IndepVal)

if iscellstr(FileName) | (numel(iSeq) > 1) | (numel(IndepVal) > 1),
    FileName = cellstr(FileName);
    Sz = [max([size(FileName, 1), size(iSeq, 1), size(IndepVal, 1)]), ...
            max([size(FileName, 2), size(iSeq, 2), size(IndepVal, 2)])];
    Nrec = max([numel(FileName), numel(iSeq), numel(IndepVal)]);
    FileName = repmat(FileName(:), Nrec-numel(FileName)+1, 1);
    iSeq = repmat(iSeq(:), Nrec-numel(iSeq)+1, 1);
    IndepVal = repmat(IndepVal(:), Nrec-numel(IndepVal)+1, 1);
    iSubSeq = zeros(Nrec, 1); %Pre-allocation ...
    for n = 1:Nrec,
        iSubSeq(n) = GetiSubSeq4IndepVal(FileName{n}, iSeq(n), IndepVal(n));
    end
    iSubSeq = reshape(iSubSeq, Sz);
else,
    try,
        ds = dataset(FileName, iSeq);
        iSubSeq = find(ds.indepval == IndepVal);
        if (prod(size(iSubSeq)) ~= 1), error('To catch block ...'); end
    catch, iSubSeq = NaN; end
end

%----------------------------------------------------------------------------