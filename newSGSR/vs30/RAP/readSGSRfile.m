function dataset=readwiscfile(dataset,directory,filename)
% readwiscfile.m
% Created: RFT 20 JUN 2000
% Modified: RFT 20 JUN 2000
%
%  readwiscfile.m   - Read a RAP-ascii file and put the data in the datasetstructure
%
%
filename=sprintf('%s%s',directory,filename)
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
      if ~isempty(findstr(string1,'Spike'))|start==1;
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
            dataset.DSNUM(conditionnumber).REP(1).data=[];
            
         end
      end
      %dataset.cond(conditionnumber)
      %pause
      %string1=string2;
      %string2 = fgets(fid);
   end
   
end
fclose(fid);

