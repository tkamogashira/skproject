% convertraptotap.m
% Created: RFT 15 MAY 2000
% Modified: RFT 10 JUL 2000
%
%  convertraptotap.m   - Convert a RAP file to the TAP format
%
% 
if isfield(dataset,'DSNUM')
   dataset = FindVariablesInRapHeader(dataset);
   %dataset.plotpar
   dataset.info.taskname='RAP';
   %dataset.info.condinfo='1';
   dataset.info.task=99;
   if ~isfield(dataset.info,'filename');
      dataset.info.filename='';
   end
   dataset.info.orifile='';
   dataset.info.variables='';
   dataset.info.para.parameters='';
   dataset.info.numberofruns=[0 0];
   dataset.info.newpos=0;
   dataset.info.cond=size(dataset.DSNUM,2);
   dataset.info.condarray=ones(1,dataset.info.cond);
   dataset.info.bandFixS1=0;
   %dataset.cond
   fprintf('Converting RAP to TAP \n %.0f conditions\n',dataset.info.cond);
   dataset.cond=[];
   for i=1:dataset.info.cond
      fprintf(' %4.0f\n',i);
      for j=1:size(dataset.DSNUM(i).REP,2)
         
         dataset.cond(i).run(j).spiketimes= dataset.DSNUM(i).REP(j).data;
         dataset.cond(i).run(j).eventtimes=...
            [0 0 0 dataset.plotpar.AW(2) ...
               dataset.plotpar.AW(2)+dataset.info.bandSacEnd];
         dataset.cond(i).run(j).eventnumbers=[0 1 2 3 5];
         dataset.cond(i).run(j).update=1;
         dataset.cond(i).run(j).answer=1;
         dataset.cond(i).run(j).trialnr=1;
         
      end
      dataset.cond(i).update=1;
      dataset.cond(i).currentrun=0;
      
      if isfield(dataset.DSNUM(i),'title')
         dataset.cond(i).title=dataset.DSNUM(i).title;
         dataset.cond(i).title=strrep(dataset.cond(i).title,char(10),'');
      else
         dataset.cond(i).title=' ';
      end
      if isfield(dataset.cond(i),'title')
         dataset.info.condinfo(dataset.info.cond+2-i)={dataset.cond(i).title};
      else
         dataset.info.condinfo(dataset.info.cond+2-i)={num2str(i-1)};
      end
   end
   dataset.info.condinfo(1)={''};
   dataset.info.xvariablevalues = nan+zeros(1,dataset.info.cond);
   %Get the logarithmic values from the titlestrings
   for ii=1:dataset.info.cond,
      ti = dataset.cond(ii).title;
      [dum ti] = strtok(ti,':');
      ti = strtok(ti,':');
      dataset.info.xvariablevalues(ii) = str2num(ti);
   end
   % disp(dataset.info.xvariablevalues)
   %Set the binning frequency to the one specified in the header
   if strcmp(upper(dataset.info.xtitlestring),'FREQ') |...
         strcmp(upper(dataset.info.xtitlestring),'FCARR') |...
         strcmp(upper(dataset.info.xtitlestring),'FMOD')
      dataset.plotpar.BF=dataset.info.xvariablevalues;
   end
   dataset.plotpar.XN = min(dataset.info.xvariablevalues);
   dataset.plotpar.XM = max(dataset.info.xvariablevalues);
   dataset.info.condx=length(dataset.info.xvariablevalues);
   dataset.info.condy=length(dataset.info.yvariablevalues);
   
   convertuppertolowercase
   dataset=rmfield(dataset,'DSNUM');
   clear i
   clear j
else
   dataset.info.condx=length(dataset.info.xvariablevalues);
   dataset.info.condy=length(dataset.info.yvariablevalues);
end

