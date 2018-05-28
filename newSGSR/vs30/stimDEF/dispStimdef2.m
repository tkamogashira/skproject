function dispStimdef2(SD);

% dispStimdef- display stimdef struct version 2

% sizes
Nwv = size(SD.waveform,2);
Nss = size(SD.subseq,2);

disp([num2str(Nwv) ' waveforms; ' num2str(Nss) ' subseqs']);
disp(['GLOBAL INFORMATION '])
dispstruct(SD.GlobalInfo);

disp('-----WAVEFORMs------')
for ii=1:Nwv,
   disp(['Waveform ' num2str(ii)])
   dispstruct(SD.waveform{ii}, 2);
end


disp('-----SUBSEQs------')
for ii=1:Nss,
   disp(['Subseq ' num2str(ii)])
   dispstruct(SD.subseq{ii}, 2);
end

if isfield(SD,'DAstats'), 
   disp('-----D/A STATS------')
   dispstruct(SD.DAstats, 2); 
end;

disp('-----PRP------')
dispstruct(SD.PRP, 2); 
