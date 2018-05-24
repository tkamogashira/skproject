function UD = getuserdata( varargin )
%GETUSERDATA Get userdata for specified recordings
%   Detailed explanation goes here

if mym(10,'status')
    try
        mym(10,'open', 'lan-srv-01.med.kuleuven.be', 'audneuro', '1monkey');
        mym(10,'use ExpData');
    catch
        UD = [];
        return
    end
end

[Mode, ExpName, CellNr, SeqNr, dsID] = localParseArg(varargin);

display(CellNr)

% get all userdata for ExpName
[Aim, Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, RecLoc, RecSide, Species, StimChan] = ...
    mym(10,['SELECT Aim, Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, RecLoc, RecSide, Species, StimChan FROM UserData_Exp WHERE FileName = "' ExpName '";']);

UD.Experiment = struct([]);
for cRow = 1:size(Aim, 1)
    UD.Experiment(cRow).Aim = Aim{cRow};
    UD.Experiment(cRow).Chan1 = Chan1{cRow};
    UD.Experiment(cRow).Chan2 = Chan2{cRow};
    UD.Experiment(cRow).DSS1 = DSS1{cRow};
    UD.Experiment(cRow).DSS2 = DSS2{cRow};
    UD.Experiment(cRow).Eval = Eval{cRow};
    UD.Experiment(cRow).ExposedStr = ExposedStr{cRow};
    UD.Experiment(cRow).RecLoc = RecLoc{cRow};
    UD.Experiment(cRow).RecSide = RecSide{cRow};
    UD.Experiment(cRow).Species = Species{cRow};
    UD.Experiment(cRow).StimChan = StimChan{cRow};
end

[Eval, Ignore, iSeq] = ...
    mym(10,['SELECT Eval, Ignore_DS, iSeq FROM UserData_DS WHERE FileName = "' ExpName '";']);

[BadSeq, BadSubSeq] = mym(10,['SELECT iSeq, SubSeq_Nr FROM UserData_BadSubSeq WHERE FileName = "' ExpName '" AND Bad = 1;']);

UD.DSInfo = struct([]);
for cRow = 1:size(Eval, 1)
    UD.DSInfo(cRow).SeqNr = iSeq(cRow);
    if ~isnan(iSeq(cRow))
        SeqID = mym(10, ['SELECT SeqID FROM KQuest_Seq WHERE FileName="' ExpName '" AND iSeq=' num2str(iSeq(cRow)) ';']);
    else
        SeqID = '';
    end
    UD.DSInfo(cRow).dsID = SeqID{1};
    UD.DSInfo(cRow).Ignore = Ignore(cRow);
    UD.DSInfo(cRow).Eval = Eval{cRow};

    idx = find(BadSeq == iSeq(cRow));
    UD.DSInfo(cRow).BadSubSeq = BadSubSeq(idx)';
end

[Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, FTCTHR, HistDepth, Ignore, Nr, RCNTHR, RecLoc, ...
    RecSide, iPass, iPen] = ...
    mym(10,['SELECT Chan1, Chan2, DSS1, DSS2, Eval, ExposedStr, FTCTHR, HistDepth, Ignore_Cell, Nr, ' ...
    'RCNTHR, RecLoc, RecSide, iPass, iPen FROM UserData_Cell WHERE FileName = "' ExpName '";']);

display(Nr)

[iCell, THRSeq] = mym(10,['SELECT iCell, THRSeq FROM UserData_CellCF WHERE FileName = "' ExpName '";']);
    
UD.CellInfo = struct([]); 
for cRow = 1:size(Chan1, 1)
    UD.CellInfo(cRow).Chan1 = Chan1{cRow};
    UD.CellInfo(cRow).Chan2 = Chan2{cRow};
    UD.CellInfo(cRow).DSS1 = DSS1{cRow};
    UD.CellInfo(cRow).DSS2 = DSS2{cRow};
    UD.CellInfo(cRow).Eval = Eval{cRow};
    UD.CellInfo(cRow).ExposedStr = ExposedStr{cRow};
    UD.CellInfo(cRow).FTCTHR = FTCTHR(cRow);
    UD.CellInfo(cRow).HistDepth = HistDepth(cRow);
    UD.CellInfo(cRow).Ignore = Ignore(cRow);
    UD.CellInfo(cRow).Nr = Nr(cRow);
    UD.CellInfo(cRow).RCNTHR = RCNTHR(cRow);
    UD.CellInfo(cRow).RecLoc = RecLoc{cRow};
    UD.CellInfo(cRow).RecSide = RecSide{cRow};
    UD.CellInfo(cRow).iPass = iPass(cRow);
    UD.CellInfo(cRow).iPen = iPen(cRow);
    
    idx = find(iCell == Nr(cRow));
    UD.CellInfo(cRow).THRSeq = THRSeq(idx)';
end


%Return requested information
switch Mode
    case 'exp' %return information as is
    case 'cell' %Only return information for this cell
        SeqNrs = getSeqNrs4Cell(log2lut(ExpName), CellNr);
        UD = AdjustUDforCell(UD, CellNr);
        UD = AdjustUDforDS(UD, SeqNrs);
    case 'ds' %Only return information for this dataset
        UD = AdjustUDforCell(UD, CellNr);
        %UD = AdjustUDforDS(UD, SeqNr);
end

mym close;

%% Local functions 
function [Mode, ExpName, CellNr, SeqNr, dsID] = localParseArg(ArgList)

[Mode, ExpName, CellNr, SeqNr, dsID] = deal([]);

switch length(ArgList)
    case 1
        if isa(ArgList{1}, 'char')
            ExpName = ArgList{1}; 
            Mode = 'exp';
        elseif isa(ArgList{1}, 'dataset')
            ds = ArgList{1};
            [ExpName, dsID, SeqNr, CellNr] = deal(ds.FileName, ds.SeqID, ds.iSeq, ds.iCell);
            if isnan(CellNr)
                warning('No cell number for this dataset. Cell related information cannot be returned.'); 
            end
            Mode = 'ds';
        else
            error('Wrong input arguments.'); 
        end
    case 2
        ExpName = ArgList{1}; 
        if ~ischar(ExpName)
            error('Wrong input arguments.'); 
        end
        if isa(ArgList{2}, 'double')
            CellNr = ArgList{2};
            Mode = 'cell';
        elseif isa(ArgList{2}, 'char')
            dsID = ArgList{2};
            [SeqNr, dsID] = GetSeqNr4dsID(log2lut(ExpName), dsID);
            if isnan(SeqNr)
                error('Dataset identifier is not unique.'); 
            end
            try
                CellNr = unraveldsID(dsID);
                if isempty(CellNr)
                    error('To catch block ...'); 
                end
            catch
                warning('No cell number for this dataset. Cell related information cannot be returned.');
                CellNr = NaN;
            end
            Mode = 'ds';
        else
            error('Wrong input arguments.'); 
        end
    otherwise
        error('Wrong number of input arguments.'); 
end

%% AdjustUDforCell
function UD = AdjustUDforCell(UD, CellNr)

%if all(isnan(CellNr))
    UD.CellInfo = struct([]);

%else
    %idx = find(ismember(cat(2, UD.CellInfo.Nr), CellNr));
    %UD.CellInfo = UD.CellInfo(idx);
%end

%% AdjustUDforDS
function UD = AdjustUDforDS(UD, SeqNr);

idx = find(ismember(cat(2, UD.DSInfo.SeqNr), SeqNr));
UD.DSInfo = UD.DSInfo(idx);