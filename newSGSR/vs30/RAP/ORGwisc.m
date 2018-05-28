% wisc.m
% Created: RFT 26 JUL 1999
% Modified: RFT 18 JUL 2000
%
%  wisc.m   - Read a RAP-ascii file and put the data in the datasetstructure
%					and save the dataset again (@@.mat).
%

pwdstring=pwd;
dire =sprintf('%s\\',pwdstring)
ext='dat';
ext='rap';

filenamestring=sprintf('%s*.%s',dire,ext)
extfiles=dir(filenamestring)


dire =sprintf('%s\\',pwdstring)

for number=1:length(extfiles)
   clear dataset
   SET_DEF
   SET_RAP
   dataset.info.taskname='RAP';
   dataset.rap=rap;
   dataset.plotpar=plotpar;
   dataset.update=1;
   directory=dataset.plotpar.DIRE;
   dataset.plotpar.DIRE=dire;
   dataset.plotpar.EXT=ext;
   dataset.calculateddata=[];
   number
   dataset=readwiscfile(dataset,...
      dataset.plotpar.DIRE,extfiles(number).name);
   convertraptotap
   commando=sprintf('save %s dataset',dataset.info.filename)
   eval(commando)
   %dataset
   %pause
end

%dataset.header
clear conditionnumber
clear directory
clear filename
clear fid
clear DSNUMnumber
clear plotpar
clear Repnumber
clear spikes
clear spiketime
clear string
clear string1
clear string2
clear string3

clear AW
clear BL
%dataset.calculateddata.histo.n=[];
%dataset.calculateddata.histo.x=[];
%end
