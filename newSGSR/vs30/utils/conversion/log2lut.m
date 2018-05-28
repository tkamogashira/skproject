function [lut, ExpInfo] = log2lut(FN,force)
% log2lut - convert experiment log file to lookup table
%   syntax:
%     [lut, ExpInfo] = log2lut(FN,force);
% Examples
%    LUT = log2lut('C0604')
%    LUT = log2lut('C0604', 1) % forces new read, ignoring any cache
%    log2lut emptyCache % empties cached log2lut data
% 
% Note: extraction of ExpInfo is based on last header only

if nargin<2
    force=0; 
end

lut = struct('iSeq', {}, 'iSeqStr', {}, 'IDstr', {});

CFN = mfilename; % cache file name

% version of log2lut (needed for cache)
Version = 2; % added ExpInfo

% Madison data: delegate to Bram's software
try
   EDF = isEDF(FN);
   MDF = isMDF(FN);
catch
   [EDF,MDF] = deal(logical(0));
end

% if isHarris(FN)
%     lut = harrisLut(FN);
%     return;
% end

if EDF
   lut = EDF2LUT(FN);
   return;
elseif MDF
   lut = MDF2Lut(FN);
   return;
end

if isequal('emptycache', lower(FN))  % empty cache, take no further action
   emptycachefile(CFN);
   return;
end

FFN = FullFileName(FN, dataDir, 'log');
DD = dir(FFN);
cacheParam = CollectInStruct(DD, Version);

% check any cached data
if ~force
   Cached = FromCacheFile(CFN, cacheParam);
   if ~isempty(Cached) % unpack & run
      try
         lut = Cached.lut;
         ExpInfo = Cached.ExpInfo;
         return 
      catch % delete corrupted cache file
         log2lut emptycache
         warning(lasterr);
      end
   end
end

% ====real work starts here======

ExpInfo = EmptyStruct('samFreqs', 'switchDur'); 
if ~exist(FFN, 'file')
    warning(['Log file ' FFN ' does not exist. Check dataDir?']);
end
fid = fopen(FFN,'rt');
NSS = 'SGSR-Seq';
OSS = 'Seq';
fsamStr = 'samFreqs:'; % 60096.1552 125000.003 Hz
iseq = 0;
while 1 % try to parse line
   ll = trimspace(fgetl(fid));
   
   if ~ischar(ll)
       break; 
   end
   
   try
      if isequal(NSS, ll(1:8)) % SGSR seq
         ww = Words2cell(ll);
         iseq = iseq+1;
         lut(iseq).iSeq = str2num(ww{2});
         lut(iseq).iSeqStr = ww{2};
         IDstr = ww{4};
         if IDstr(1)=='<'
             lut(iseq).IDstr = IDstr(2:end-1);
         else
             lut(iseq).IDstr = '';
         end
      end
   end
   
   try
      if isequal(OSS, ll(1:3)) % IDF/SPK seq
         ww = Words2cell(ll);
         iseq = iseq+1;
         lut(iseq).iSeq = -str2num(ww{2});
         lut(iseq).iSeqStr = ['-' ww{2}];
         IDstr = ww{4};
         if IDstr(1)=='<'
             lut(iseq).IDstr = IDstr(2:end-1);
         else
             lut(iseq).IDstr = ww{3}(2:end-1);
         end
      end
   end % try/catch

   try
      L = length(fsamStr);
      if isequal(fsamStr, ll(1:L)) % SGSR version
         ww = Words2cell(ll(L+1:end), ' ');
         for iii=1:length(ww)-1
             sf(iii) = str2num(ww{iii}); 
         end
         ExpInfo(1).samFreqs = sf;
         ExpInfo(1).switchDur = 80; 
      end
   end % try/catch
end % while
fclose(fid);

% Cache = collectInstruct(lut, ExpInfo);
% ToCacheFile(CFN, 500, cacheParam, Cache);

% =======header example===========
% ExpInfo = local_getExpinfo(DD);
% Session initialized: C0604
%   Started @: 3 4 2006 15 47 31
%   Experimenter: Philip
%   Rec Side: Left
%   D/A chan: B
%   ERC: C:\SGSRwork\ExpData\C0604.ERC
%   SGSR version: 3.09
%   samFreqs: 60096.1552 125000.003 Hz
%   maxSampleRatio: 0.4
%   ClockRatio: 0.99999018627298