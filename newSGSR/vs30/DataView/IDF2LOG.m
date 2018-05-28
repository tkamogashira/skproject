function IDF2LOG(DF);
% IDF2LOG - generate LOG file from IDF datafile
%   IDF2LOG FOO generates foo.log from datafile foo.idf.
%   This is useful for browsing data collected using the DSS setup.

IDFname = fullFileName(DF, bdatadir, 'idf');
if ~exist(IDFname), error(['IDF file ''' DF ''' not found in folder ''' bdatadir '''.']); end;
LOGname = fullFileName(DF, bdatadir, 'log');
if exist(LOGname), error(['LOG file ''' DF ''' already exists.']); end;

IDF = idfread(IDFname);
Nseq = length(IDF.sequence);
if Nseq>0, ddate = IDF.sequence{1}.stimcntrl.today;
else, ddate = [11 12 1962 14 18 0];
end
DateStr = ['Started @: ' trimspace(num2str(ddate))];
fid = fopen(LOGname,'wt+');
fprintf(fid, '%s\n', DateStr);
for ii=1:Nseq,
   seq = IDF.sequence{ii};
   iseq = seq.stimcntrl.seqnum;
   MenuName = upper(IDFstimname(seq.stimcntrl.stimtype));
   line = ['Seq ' num2str(iseq) ' (' MenuName ') saved'];
   fprintf(fid, '%s\n', line);
end
fclose(fid);

%Started @: 9 6 2002 22 9 26
%Seq 1 (FS) <113-5-FS>  saved

