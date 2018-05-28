function H = HeaderSGSRdataFile(DataFileName);
% HeaderSGSRdataFile - returns header of SGSR data file
EXT = '.SGSR';
if nargin<1,
   DataFileName = datafile(EXT);
else,
   DataFileName = [datadir filesep DataFileName EXT];
end
try,
   if isempty(DataFileName), error('empty'); end % error will be caught below
   H = load(DataFileName, 'Directory', '-mat');
   H = H.Directory;
catch
   H = struct('Nseq', 0, 'SeqNames', {{}});
end
