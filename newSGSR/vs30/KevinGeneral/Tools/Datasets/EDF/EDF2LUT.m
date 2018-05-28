function [LUT, HDR] = EDF2LUT(FileName)
%EDF2LUT get lookup table for EDF datafile
%   T = EDF2LUT(FN) makes lookup table T with all entries from EDF datafile given by FN
%   [T, H] = EDF2LUT(FN) also returns header information
%
%   See also LOG2LUT

%B. Van de Sande 19-04-2004

if nargin ~= 1
    error('Wrong number of input arguments.'); 
end

LUT = struct('iSeq', {}, 'iSeqStr', {}, 'IDstr', {});

[FullFileName, FileName] = parseEDFFileName(FileName);
if ~exist(FullFileName, 'file')
    error('First argument should be name of EDF.'); 
end

SearchParam = dir(FullFileName);
Data = FromCacheFile(mfilename, SearchParam);
if isempty(Data)
    %Opening of datafile in binary mode ...
    fid = fopen(FullFileName, 'r', 'ieee-le');
    if fid == -1
        error(sprintf('Couldn''t open file %s.', FullFileName)); 
    end
    
    %Reading in directory structure ...
    HDR = readEDFDirHeader(fid);
    
    for n = 1:HDR.NEntries
        DirEntry = readEDFDirEntry(fid, n);
        DsHeader = readEDFDsHeader(fid, DirEntry.DsLoc);
        
        %General information...
        LUT(n).iSeq    = n;
        LUT(n).iSeqStr = int2str(n);
        LUT(n).IDstr   = DirEntry.DsID;
        LUT(n).ExpType = DirEntry.ExpType;
        LUT(n).RecTime = DsHeader.RecTime;
        
        %Dataset retrieval information...
        LUT(n).SchName = DirEntry.SchName; %Schema-type of dataset ...
        LUT(n).DsLoc   = DirEntry.DsLoc;   %Location of dataset in blocks ... (1 block is 512 bytes or 128 words)
        LUT(n).DsSize  = DirEntry.DsSize;  %Size of dataset in blocks ...
    end
    
    fclose(fid);
    
    ToCacheFile(mfilename, +100, SearchParam, CollectInStruct(LUT, HDR));
else
    [LUT, HDR] = deal(Data.LUT, Data.HDR); 
end