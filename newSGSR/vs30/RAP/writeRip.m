function writeRip(fname, Nseq);

if isnumeric(fname), fname = [PDPtestSetName(fname)]; end;

IDF = idfread(fname);
IDF = IDF.sequence{Nseq};

SPK = spkextractseq(fname, Nseq);

Interval = IDF.stimcntrl.interval;
% try to extract burst duration
Dur = nan;

if isfield(IDF.indiv,'stimcmn'),
   if isfield(IDF.indiv.stimcmn,'duration'),
      Dur = IDF.indiv.stimcmn.duration;
   % elseif isfield(IDF.indiv.stimcmn,'click_dur'),
   %   Dur = 1e-3*IDF.indiv.stimcmn.click_dur;
   end
else,
   if isfield(IDF.indiv.stim{1},'duration'),
      d1 = IDF.indiv.stim{1}.duration;
      d2 = IDF.indiv.stim{2}.duration;
      Dur = max(d1,d2);
   end
end
if isnan(Dur), % give up
   Dur = Interval;
end

[Nsub Nrep] = size(SPK.spikeTime);

SMS = idf2sms(IDF);

xName = SMS.PRP.plotInfo.xlabel;
xName = strtok(xName,'(');
if ~isempty(findstr('freq',lower(xName))),
   xName = 'freq'
end
   
% if length(xName)>8, xName=xName(1:8); end;
vv = SMS.PRP.plotInfo.varValues;
xval = [min(vv) max(vv) mean(diff(vv))];

yName = 'NONE';
yval = [0 0 0];

cmenu = upper(idfstimname(IDF.stimcntrl.stimtype));

iseq = IDF.stimcntrl.seqnum;

datasetName = [num2str(iseq) '-' cmenu];

aa = IDF.stimcntrl.activechan;
switch aa
case 0, ActChan = 'YY';
case 1, ActChan = 'YN';
case 2, ActChan = 'NY';
end
%----------------------------
% function h = RAPheader(datasetName, dataFileName, Nrep, Dur, Interval, ActChan, xName, xVal, yName, yVal, Awin, MinIS, trialWin);
Header = rapHeader(datasetName,fname, Nrep, Dur, Interval, ActChan, xName, xval, yName, yval);

FN = [fname '-' datasetName '.rip'];
fid =fopen(FN,'wt');
fprintf(fid,'%c',Header);
for isub=1:Nsub,
   xx = SPK.subseqInfo{isub}.var1;
   if all(xx==0), x = 0;
   else,
      xx = xx(find(xx~=0));
      x = max(xx);
   end
   fprintf(fid,'%s  : %f \n',xName,x);
   for irep=1:Nrep,
      fprintf(fid,'Rep #  %d\n', irep);
      spt = SPK.spikeTime{isub,irep};
      if ~isempty(spt), fprintf(fid,'  %f\n', spt); end;
   end
end

fprintf(fid,'--------------------------------');

fclose(fid);



