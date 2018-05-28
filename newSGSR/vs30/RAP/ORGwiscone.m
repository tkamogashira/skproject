% wiscone.m
% Created: RFT 26 JUL 1999
% Modified: RFT 27 JUN 2000
%
%  wiscone.m   - Read only 1 RAP-ascii file and put the datat in the datasetstructure
%                File specified by dire='\\bigscreen\usr\philip\ic\R@@@@@\'
%                         and      id='@@@@.dat'
%


clear dataset
if ~exist('dataset')
   SET_DEF
   SET_RAP
   %ID='11-2-ab.dat';
   %if isunix
   %   dire='/usr/people/raoul/matlab/'
   %else
   %   dire='\\Bigscreen\usr\Philip\ic\R99040\';
   %end
   
   NB=100;
   %XM=5;
   %XN=0;
   %OL=0;
   PR=0;
   %dataset.update =1;
end
dataset.info.taskname='RAP';
%XM=10;
%XN=0;

if isfield(dataset,'rap')
   rap=dataset.rap;
else
   SET_RAP 
end
if isfield(dataset,'plotpar')
   plotpar=dataset.plotpar;
else
   SET_DEF
end
%who
%id
plotpar.EXT='dat';
%dire='\\Bigscreen\usr\Philip\ic\temp\';
ChangePlotpar
%plotpar
dataset.plotpar=plotpar;
if exist('rap')
   dataset.rap=rap;
end
%plotpar
dataset.update=dataset.plotpar.update;

directory=dataset.plotpar.DIRE;
if dataset.update  
   
   if isfield(dataset,'DSNUM')
      dataset=rmfield(dataset,'DSNUM');
      %else
   end
   filename=sprintf('%s%s',directory,dataset.plotpar.ID)
   fid = fopen(filename,'r');
   if fid <1 disp('	File not found');
      dirinfo = sprintf('%s%s',directory,dataset.plotpar.ID);
      dir (dirinfo)
      dir
      newpos=0;
   else
      conditionnumber=0;
      %dataset.DSNUM=[]
      string1 = fgets(fid);
      string2 = fgets(fid);
      start=1;
      while feof(fid)==0;
         %Go into the header only when the word spike is in it
         if ~isempty(findstr(string1,'Spike'))|start==1
            dataset.header='';
            while isempty(findstr(string2,'Rep'))
               dataset.header=sprintf('%s%s\n',dataset.header,string1);
               %string1
               %double(string1)
               %pause
               % stay in loop as long as *Rep*
               string1 = string2;
               string2 = fgetl(fid);
            end
            %Remove some linefeeds to compact the header!
            dataset.header=strrep(dataset.header,[char(10) char(10)],char(10));
            dataset.header=strrep(dataset.header,char(13),'');
            dataset.header
            start=0;
         end
         if ~isempty(findstr(string1,':'))
            conditionnumber=conditionnumber+1;
            while ~isempty(findstr(string1,'     '))
               string1=strrep(string1,'     ',' ');
            end
            dataset.DSNUM(conditionnumber).title=string1;
            %Remove some linefeeds to compact the title! 
            dataset.DSNUM(conditionnumber).title=...
               strrep(dataset.DSNUM(conditionnumber).title,...
               [char(10) char(10)],char(10));
            dataset.DSNUM(conditionnumber).title=...
               strrep(dataset.DSNUM(conditionnumber).title,char(13),'');
            
         end
         while isempty(findstr(string2,':')) & isempty(findstr(string2,'-------'))
            %if ~isempty(findstr(string2,'Rep'))
            string3=sscanf(string2,'%s%s%g');
            Repnumber=string3(5);
            spikes=[];
            string2 = fgets(fid);
            while isempty(findstr(string2,'Rep'))...
                  & isempty(findstr(string2,':'))...
                  & isempty(findstr(string2,'-------'));
               spiketime=str2num(string2);
               spikes=[spikes spiketime];
               %string1=string2;
               string2 = fgets(fid);
            end
            %conditionnumber
            %Repnumber
            %dataset.cond(conditionnumber).REP(Repnumber).data=[spikes];
            %dataset.cond(conditionnumber).update=1;
            %dataset.cond(conditionnumber).currentrun=0;
            dataset.DSNUM(conditionnumber).REP(Repnumber).data=[spikes];
            %end
            
         end
         string1=string2;
         string2=fgets(fid);
         conditionnumber
         if feof(fid)==1
            %when the file ends with a new condition followed by a
            %------------- we need to add the previous line as a new
            %condition
            %Otherwise the title says there is one condition more than
            %there are in the structure
            if ~isempty(findstr(string1,':'))
               conditionnumber=conditionnumber+1;
               while ~isempty(findstr(string1,'     '))
                  string1=strrep(string1,'     ',' ');
               end
               dataset.DSNUM(conditionnumber).title=string1;
               %Remove some linefeeds to compact the title! 
               dataset.DSNUM(conditionnumber).title=...
                  strrep(dataset.DSNUM(conditionnumber).title,...
                  [char(10) char(10)],char(10));
               dataset.DSNUM(conditionnumber).title=...
                  strrep(dataset.DSNUM(conditionnumber).title,char(13),'');
               dataset.DSNUM(conditionnumber).REP=[];
               
            end
         end
         
         
         %dataset.cond(conditionnumber)
         %pause
         %string1=string2;
         %string2 = fgets(fid);
         
      end
   end
   fclose(fid);
   
end
convertraptotap
dataset.info.filename;
commando=sprintf('save %s dataset',dataset.info.filename)
eval(commando)

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
clear start
clear string
clear string1
clear string2
clear string3
dataset.calculateddata =[];
resetparameters;

clear AW
clear BL
%dataset.calculateddata.histo.n=[];
%dataset.calculateddata.histo.x=[];
%end
