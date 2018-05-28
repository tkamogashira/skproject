function [LUT, HDR] = mad2lut(FileName, varargin)
%MAD2LUT Convert Madison datafile to lookup table
%   T = MAD2LUT(FN) makes lookup table T with all entries from madison datafile given by FN
%
%   [T, H] = MAD2LUT(FN) also returns header information
%
%   Optional properties and their values can be given as a comma-separated list. To view list
%   of all possible properties and their default value, use 'list' as only property.
%
%   See also LOG2LUT

%B. Van de Sande 04-07-2003
%Integratie van MADISON datafiles in SGSR

DefParam.mode = 'converted'; %Normal, extended or converted ...

if nargin < 1
    error('Wrong number of input arguments.');
end
if ~existmaddata(FileName)
    error(sprintf('%s doesn''t exist.', FileName));
end

Param = checkproplist(DefParam, varargin{:});
if ~any(strncmpi(Param.mode, {'n', 'e', 'c'}, 1))
    error('Invalid value for property mode.');
end

DF = CheckMadisonDataFile(FileName);
FullFileName = fullfile(DF.Path, [DF.FileName, DF.FileExt]);

%Openen van Madison datafile in binaire mode ...
fid = fopen(FullFileName, 'r', 'ieee-le');
if fid == -1
    error('Couldn''t open datafile.');
end

%Directory structuur inlezen ...
HDR = getfields(GetMadisonDirHeader(fid), {'AnimalID', 'NEntries', 'LastModified'});

ExtMode  = strncmpi(Param.mode, 'e', 1);
ConvMode = strncmpi(Param.mode, 'c', 1);
for EntryNr = 1:HDR.NEntries
    DirEntry = GetMadisonDirEntry(fid, EntryNr);
    LUT(EntryNr).iSeq    = EntryNr;
    LUT(EntryNr).iSeqStr = int2str(EntryNr);
    LUT(EntryNr).IDStr   = DirEntry.DataSetID;
    
    if ExtMode
        LUT(EntryNr).ExpType = DirEntry.ExpType;
        LUT(EntryNr).Scheme  = DirEntry.SchemaName;
    end
    if ConvMode
        [CellNr, TestNr, StimType] = ConvMadisonOrgdsID(DF, DirEntry.DataSetID);
        if ~isempty(CellNr)
            LUT(EntryNr).ConvIDStr = ...
                sprintf('%d-%d-%s', CellNr, TestNr, lower(StimType));
        else
            LUT(EntryNr).ConvIDStr = '';
        end
    end
end

fclose(fid);
