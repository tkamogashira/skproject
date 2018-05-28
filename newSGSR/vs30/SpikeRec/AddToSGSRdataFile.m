function iseq = AddToSGSRdataFile(FileName, SpikeInfo);
% spike saver for non-PDP11 data - temporary for Susanne's convenience

Npad = 3;
fullFileName = [FileName '.SGSR'];
ExistingFile = isequal(2,exist(fullFileName));
if ExistingFile,
   % file exists, load directory and update it
   load(fullFileName, 'Directory', '-mat');
   iseq = Directory.Nseq + 1;
else, % create new data file
   iseq = 1;
   Directory = [];
end
Directory.Nseq = iseq;
SeqName = ['Sequence' zeroPaddedNumberStr(iseq,Npad)];
Directory.SeqNames{iseq} = SeqName;
% store SpikeInfo in variable named SeqName
eval([SeqName '= SpikeInfo;']);
% write updated directory and new sequemce to file
if ExistingFile,
   save(fullFileName, 'Directory', SeqName, '-append');
else,
   save(fullFileName, 'Directory', SeqName);
end

