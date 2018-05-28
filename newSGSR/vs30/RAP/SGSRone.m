% SGSRone.m
% Created: MH 28 NOV 2000
%
% adapted from:
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
%--------------------------------------------
%
%ff = 
%       info: [1x1 struct]
%    plotpar: [1x1 struct]
%        rap: [1x1 struct]
%        update: 1%
%
%dd = 
%              info: [1x1 struct]
%               rap: [1x1 struct]
%           plotpar: [1x1 struct]
%            update: 1
%    calculateddata: []
%            header: [1x491 char]
%              cond: [1x10 struct]
%dd.info=
%   taskname: 'RAP'
%       xtitlestring: 'freq'
%    xvariablevalues: [1x10 double]
%       ytitlestring: ''
%    yvariablevalues: 1
%              condx: 10
%              condy: 1
%         bandSacEnd: 500
%           filename: 'R99039-11-1-SERBB'
%               task: 99
%            orifile: ''
%          variables: ''
%               para: [1x1 struct]
%       numberofruns: [0 0]
%             newpos: 0
%               cond: 10
%          condarray: [1 1 1 1 1 1 1 1 1 1]
%          bandFixS1: 0
%           condinfo: {1x11 cell}
%           
%dd.info.condinfo =
%  Columns 1 through 5
%     ''    [1x21 char]    [1x21 char]    [1x21 char]    [1x21 char]
%  Columns 6 through 8
%    ' freq    : 922.2 '    ' freq    : 777.8 '    ' freq    : 633.3 '
%  Columns 9 through 11
%    ' freq    : 488.9 '    ' freq    : 344.4 '    ' freq    : 200.0 '
%    
%dd.plotpar.AW
%           0        3000   
%           
%dd.plotpar.BF=
%  1.0e+003 *
%  Columns 1 through 7 
%    0.2000    0.3444    0.4889    0.6333    0.7778    0.9222    1.0667
%  Columns 8 through 10 
%    1.2111    1.3556    1.5000   
   
%dd.plotpar.EXT=
%rap   
   
%dd.header =
%FDIFFS=          2
% Spike Time values for data set : 11-1-SERBB     Data File : R99039                                                      
% Stimulus :    1 X  3000.0/  3500.0 msecs      DSS-1:Y   DSS-2:Y                                                         
% freq    :   200.0/  1500.0/   144.4           NONE : 1.000/ 1.000/ 1.000                                
% Analysis window : 0.-3500. millisecs       Min IS: 0.300 ms Trials : 1-1      
   
%dd.cond(2) = 
%           run: [1x1 struct]
%        update: 1
%    currentrun: 0
%         title: ' freq    : 344.4 '  
%   
%dd.cond(2).run = 
%      spiketimes: []
%      eventtimes: [0 0 0 3000 3500]
%    eventnumbers: [0 1 2 3 5]
%          update: 1
%          answer: 1
%         trialnr: 1
%   
%   
%   
%   
   
   %-------------------------------------------
   
   filename=sprintf('%s%s',directory,dataset.plotpar.ID)
   fid = fopen(filename,'r');
   if fid <1 disp('	File not found');
      dirinfo = sprintf('%s%s',directory,dataset.plotpar.ID);
      dir (dirinfo)
      dir
      newpos=0;
      return;
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
