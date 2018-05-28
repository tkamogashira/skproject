function [CellsCellArray, FreqBound] = GetCellsinFreqRange(DataFile, RefCell, StimType, FreqRange, DirInfo)
%GETCELLSINFREQRANGE    gets cells with same stimulus type as reference cell and with CF in specified 
%                       frequency range out of datafile.
%   [CellList, FreqBound] = GETCELLSINFREQRANGE(DataFile, RefCell, StimType, FreqRange, DirInfo)

CellNr = RefCell.CellNr;
TestNr = RefCell.TestNr;
SParam = CollectInStruct(DataFile, CellNr, TestNr);
Data   = FromCacheFile(DirInfo.TableFile, SParam);

FreqHigh = Data.CF + FreqRange;
FreqLow  = max([0 (Data.CF - FreqRange)]);
FreqBound = [ FreqLow FreqHigh ];

load(DirInfo.TableFile, 'N', '-mat');
load(DirInfo.TableFile, 'Pars', '-mat'); SParam = Pars;
load(DirInfo.TableFile, 'Data', '-mat');

CellsCellArray = cell(0);
for i = 1:N
    if strcmp(SParam{i}.DataFile, DataFile)      & ...
       strcmp(upper(Data{i}.StimType), StimType) & ...     
       ((Data{i}.CF > FreqLow) & (Data{i}.CF < FreqHigh))
        dsID = [int2str(SParam{i}.CellNr) '-' int2str(SParam{i}.TestNr)];
        CellsCellArray = cat(1,CellsCellArray(:), {dsID});
    end    
end
