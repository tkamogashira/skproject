function ArgOut = expview(varargin)
%EXPVIEW  get overview of an experiment
%   EXPVIEW(FileName) gives an overview of the experiment with filename given by 
%   the character string FileName.
%   EXPVIEW(FileName1, FileName2, ..., FileNameN) gives an overview of multiple
%   datafiles.
%   T = EXPVIEW(FileName) also returns the structure-array containing the actual
%   displayed information.

%B. Van de Sande 28-04-2004

%Parse input arguments and assemble datafile information ...
if (nargin < 1)
    error('Wrong number of input arguments.');
end
[DFI, ErrTxt] = AssembleDFInfo(varargin{:});
error(ErrTxt);

%Assembling table with requested information ...
NDF = length(DFI);
T = [];
if (NDF < 5)
    TitleStr = FormatCell({DFI.FileName}, {'', ''}, ',');
else
    TitleStr = [FormatCell({DFI(1:3).FileName}, {'', ''}, ',') ', ..., ' ...
        FormatCell({DFI(end-2:end).FileName}, {'', ''}, ',')];
end

Hdl = waitbar(0, sprintf('Assembling overview of %s ...', TitleStr), 'Name', 'ExpView');
NTotal = sum(cat(2, DFI.NCells));

for n = 1:NDF
    if (n == 1)
        NBgn = 0;
    else
        NBgn = sum(cat(2, DFI(1:n-1).NCells));
    end
    Tsingle = AddDataFile(DFI(n), Hdl, NBgn, NTotal);
    if isempty(Tsingle)
        return;
    else
        T = [T, Tsingle];
    end
end

delete(Hdl);

%Displaying information ...
structview(T, 'titletxt', sprintf('Overview of %s', TitleStr));

if (nargout == 1)
    ArgOut = T;
end

%-----------------------------------locals----------------------------------------
function [DFI, ErrTxt] = AssembleDFInfo(varargin)

DFI = [];
ErrTxt = '';

NDF = nargin;
for n = 1:NDF
    FileName = varargin{n};
    
    [Path, FileName, FileExt] = fileparts(upper(FileName));
    if isempty(Path)
        Path = upper(datadir);
    end
    if isempty(FileName)
        ErrTxt = 'Invalid filename.';
        return;
    end
    if isempty(FileExt)
        FileExt = '.LOG';
    end
    FullFileName = fullfile(Path, [FileName FileExt]);
    
    try
        LUT = log2lut(FullFileName); 
    catch
        ErrTxt = sprintf('Experiment with filename ''%s'' doesn''t exist.', ...
            FileName);
        return;
    end
    if isempty(LUT)
        warning('Experiment with filename ''%s'' contains no entries and is discarded.', FileName);
        continue;
    end
    
    NElem    = length(LUT);
    iDS      = cat(1, LUT.iSeq);
    dsIDs    = {LUT.IDstr}';
    Nrs      = char2num(char(LUT.IDstr), 2, '-');
    [iCell, iTest] = deal(Nrs(:, 1), Nrs(:, 2));
    StimType = GetStimType(dsIDs);
    
    idx = find(isnan(iCell));
    if ~isempty(idx)
        warning('Some entries in ''%s'' are discarded because of invalid cell number.', ...
            FileName); 
        NElem = NElem - length(idx);
        iDS(idx) = [];
        iCell(idx) = [];
        iTest(idx) = [];
        dsIDs(idx) = [];
        StimType(idx) = [];
    end
    
    CellList = unique(iCell);
    NCells   = length(CellList);
    
    DFI = [DFI CollectInStruct(FileName, FullFileName, NElem, iDS, dsIDs, ...
        iCell, iTest, StimType, NCells, CellList)];
end

%---------------------------------------------------------------------------------
function StimType = GetStimType(dsIDs)

NIDs = length(dsIDs);
StimType = cell(NIDs, 1);
for n = 1:NIDs
    dsID = dsIDs{n};
    idx = findstr(dsID, '-');
    N = length(idx);
    if (N == 2)
        StimType{n} = lower(dsID(idx(2)+1:end));
    elseif (N >= 3)
        StimType{n} = lower(dsID(idx(2)+1:idx(3)-1));    
    else
        StimType{n} = '';
    end
end

%---------------------------------------------------------------------------------
function T = AddDataFile(DFI, Hdl, NBgn, NTotal)

T = [];

StimTypes = menufiglist;
StimTypes(strcmpi(StimTypes, 'THR')) = [];

SearchParam.DataFile  = dir(DFI.FullFileName);
SearchParam.StimTypes = StimTypes;
T = FromCacheFile(mfilename, SearchParam);
if ~isempty(T)
    warning('Data read from cache for ''%s'' ...', DFI.FileName);
else
    for n = 1:DFI.NCells
        if ishandle(Hdl)
            waitbar((NBgn+n)/NTotal, Hdl); 
        else
            T = [];
            return;
        end
        
        CellNr   = DFI.CellList(n);
        StimType = DFI.StimType(ismember(DFI.iCell, CellNr));
        UD       = GetUserData(DFI.FileName, CellNr);
        
        if UD.CellInfo.Ignore
            continue;
        end
        
        %General information ...
        Tsingle.DataFile     = DFI.FileName;
        Tsingle.CellNr       = CellNr;

        Tsingle.ExposedStr   = UD.CellInfo.ExposedStr;
        Tsingle.RecSide      = UD.CellInfo.RecSide;
        
        %Histology information ...
        Tsingle.Hist.RecLoc  = UD.CellInfo.RecLoc;
        Tsingle.Hist.iPen    = UD.CellInfo.iPen;
        Tsingle.Hist.iPass   = UD.CellInfo.iPass;
        Tsingle.Hist.Depth   = UD.CellInfo.HistDepth;
        
        %Threshold curve information ...
        NRec = length(find(strncmpi(StimType, 'th', 2)));
        if ~isnan(UD.CellInfo.THRSeq)
            iSeq = UD.CellInfo.THRSeq;
            dsTHR = dataset(DFI.FileName, iSeq);
            [CF, SR, Thr, BW, Q10] = evalTHR(dsTHR, 'plot', 'no');
        else
            [iSeq, CF, SR, Thr, BW, Q10] = deal(NaN);
        end
        Tsingle.Thr = CollectInStruct(NRec, iSeq, CF, SR, Thr, BW, Q10);
        
        %Information of other datasets ...
        NST = length(StimTypes);
        for ns = 1:NST
            NStim = length(find(ismember(StimType, StimTypes{ns})));
            Tsingle.(upper(StimTypes{ns})) = struct('Nr', NStim);
        end    
        
        T = [T, Tsingle];
    end
    
    ToCacheFile(mfilename, +100, SearchParam, T);
end

%---------------------------------------------------------------------------------