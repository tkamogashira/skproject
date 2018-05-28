function dispStimdef(SD);

% dispStimdef- display stimdef struct

% sizes
Nwv = size(SD.waveform,2);
Nss = size(SD.subseq,2);

disp([num2str(Nwv) ' waveforms; ' num2str(Nss) ' subseqs']);
% disp(['calibration: ' SD.calib]);


disp('-----SUBSEQs------')
for ii=1:Nss,
   disp(['Subseq ' num2str(ii)])
   dispstruct(SD.subseq{ii}, 2);
end

disp('-----WAVEFORMs------')
for ii=1:Nwv,
   disp(['Waveform ' num2str(ii)])
   dispstruct(SD.waveform{ii}, 2);
end
disp('-----D/A STATS------')
   dispstruct(SD.DAstats, 2);

disp('-----GlobalInfo------')
   dispstruct(SD.GlobalInfo, 2);
   
disp('-----PRP------')
   dispstruct(SD.PRP, 2);
