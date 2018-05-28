function spk = SPKread(fname, form, maxRec)
persistent IHaveWarnedYou
% function spk = SPKread(N, form);
%

if nargin<1
	fname='';
end
if nargin<2
	%-- 06/02/10 peterbr -> R2009 does not support vaxd anymore --%
% 	if( isunix )
 		form='ieee-le';
% 	else
% 		form='ieee-be';
% 	end
end
if nargin<3
	maxRec = inf;
end

% complete file name; IDF file in ExpData dir
fname = PDPtestSetName(fname); % convert if member of ancient test set
fname = FullFileName(fname, dataDir, 'SPK', 'SPK file');

%--------SIZE-----------
[fid mess] = fopen(fname, 'r', form);
if ~isempty(mess)
    error(mess);
end

spk.filename = fname;
% read directory blocks only
ii = 1;
while true
   rec = SPKreadBlock(fid, ii);
   if ~isequal(rec.data_rec_kind,1)
       return
   end
   REC{ii} = rec;
   if ii>=ceil(REC{1}.num_data_sets/24) % past the filled dirs
       break
   end
   ii = ii +1;
end
clear ii
fclose(fid);

spk.header = rmfield(REC{1},'directory');
if isequal(spk.header.num_data_sets, 0)
   spk.dir = {}; 
end

for irec=1:length(REC)
   for iEntry=1:24
      loc = 24*(irec-1)+iEntry;
      if loc>spk.header.num_data_sets
          break
      end
      spk.dir(loc) = REC{irec}.directory(iEntry);
   end
end

% try to fix corrupt datasets containing empty datasets
DDD = [spk.dir{:}];
if ~isempty(DDD)
   iempty = find([DDD.num_blocks]==0);
   if ~isempty(iempty)
      if ~isequal(fname,IHaveWarnedYou)
         warning('Empty dataset(s) in SPK file will be ignored.');
         IHaveWarnedYou = fname; % warn just once per session per SPKfile
      end
      spk.dir(iempty) = [];
      spk.header.num_data_sets = spk.header.num_data_sets - length(iempty);
   end
end
