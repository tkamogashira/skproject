function log2table(ExpName, varargin)
%LOG2TABLE  convert a log file to a TAB-delimited table
%   LOG2TABLE(ExpName) converts the log file of the experiment with name ExpName to a TAB-delimited
%   text file. This text file contains information on each dataset, including the characteristic frequency
%   and spontanuous activity taken from the last threshold curve from the cell to which a dataset belongs.
%   The txt file is generated in the current directory and has the same name as the experiment with .txt as
%   extension.
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default values, use 'list' as only property.

%B. Van de Sande 01-08-2003

DefParam.stimtypes = {};

if nargin < 1, error('Wrong number of input arguments.'); end
[FullExpName, ExpName] = parseFileName(ExpName, '.log');
if isempty(FullExpName), error('First argument should be name of experiment.'); end
FullTxtName = parseFileName(ExpName, '.txt');

Param = checkproplist(DefParam, varargin{:});
    
LUT = log2lut(ExpName);
IDList = char(LUT.IDstr);
AllCellNrs = char2num(IDList);

fid = fopen(FullTxtName, 'wt'); if fid < 0, error(sprintf('Cannot open file %s.', FullTxtName)); end
fprintf(fid, 'FileName\tCellNr\tTestNr\tStimType\tCF\tSA\n');

Hdl = waitbar(0, sprintf('Generating table for %s ...', ExpName), 'Name', 'log2table');

NEntries = length(LUT);
for n = 1:NEntries,
    if ishandle(Hdl), waitbar(n/NEntries, Hdl); else, fclose(fid); return; end
    [CellNr, TestNr, dsID, StimType] = unraveldsID(LUT(n).IDstr); StimType = strtok(StimType, '-');
    if ~isempty(Param.stimtypes) & ~any(strcmpi(StimType, Param.stimtypes)), continue; end
    
    idx = max(intersect(find(AllCellNrs == CellNr), strfindcell(IDList, 'THR')));
    if ~isempty(idx), 
        THRSeqNr = LUT(idx).iSeq;    
        ds = dataset(ExpName, THRSeqNr);
        [CF, SA] = evalTHR(ds);
    else, [CF, SA] = deal(NaN); end    
    
    fprintf(fid, '%s\t%d\t%d\t%s\t%.2f\t%.2f\n', ExpName, CellNr, TestNr, StimType, CF, SA);
end    

delete(Hdl);
fclose(fid);

%-----------------------------------------------local functions------------------------------------------------
function [FullFileName, FileName] = parseFileName(FileName, DefExt)

[Path, FileName, FileExt] = fileparts(FileName);
if isempty(Path),     Path = pwd; end
if isempty(FileExt),  FileExt = DefExt; end
if isempty(FileName), FullFileName = [];
else, FullFileName = fullfile(Path, [FileName FileExt]); end

function [CF, SA] = evalTHR(ds)

[db, index] = min(ds.OtherData.thrCurve.threshold);
CF = ds.OtherData.thrCurve.freq(index);

spt = ds.spt;
SA = (length([spt{1,:}]) * 1000) / (ds.burstdur * length(ds.spt));