function [idf, fname]=IDFread(fname,form)

% function idf=IDFread(N,form);
%

global DEFDIRS

if nargin<1
    N=1;
end
if nargin<2
    form='ieee-le';
end

%if nargin<2
	%-- 06/02/10 peterbr -> R2009 does not support vaxd anymore --%
% 	if( isunix )
% 		form='ieee-le';
% 	else
% 		form='ieee-be';
% 	end
%end

% complete file name; IDF file in ExpData dir
fname = PDPtestSetName(fname); % convert if member of ancient test set
fname = FullFileName(fname, dataDir, 'IDF', 'IDF file');


%--------SIZE-----------
[fid mess] = fopen(fname, 'r', form);
freadVAXD(fid,inf,'uchar');
fclose(fid);
% disp(['size: ' num2str(count) ' bytes (' num2str(count/256) ' recs)']);

[fid mess] = fopen(fname, 'r', form);
% ------HEADER----------
idf.header = IDFheaderRead(fid);

% disp(['extra bytes: ' num2str(count-256*(idf.header.num_seqs+1))]);
% blocks
if isequal(0,idf.header.num_seqs)
   [dum fn] = fileparts(fname);
   if isequal(upper(fn),'D0209')
      idf.header.num_seqs=256;
   else
      idf.sequence = {};
   end
end

for iblock=1:idf.header.num_seqs
   fseek(fid, 256*iblock, 'bof');
   idf.sequence{iblock}.stimcntrl = IDFreadstimcommon(fid);
   stType = idf.sequence{iblock}.stimcntrl.stimtype;
   stimName = IDFstimname(stType);
   readfunction = ['IDFreadstim' upper(stimName)];
   if (exist(readfunction)==2),
      if strcmp(stimName,'ici'), % misalignment bug fix
         seqDate = idf.sequence{iblock}.stimcntrl.today;
         idf.sequence{iblock}.indiv = feval(readfunction,fid,seqDate);
      else
          idf.sequence{iblock}.indiv = feval(readfunction,fid);
      end
   else
      warning(['don''t know how to read stim type ' stimName])
      idf.sequence{iblock}.indiv = [];
   end
end
fclose(fid);
