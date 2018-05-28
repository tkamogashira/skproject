function [xL, xR] = ExtractStimGENparams(SD, fieldname);

% function [xL, xR] = ExtractStimgenParams(SD, fieldname);

Nsubseq = length(SD.subseq);
xL = cell(1,Nsubseq);
xR = cell(1,Nsubseq);
played = SD.PRP.playOrder;
iPlay = 1;
for isubseq = played(:)',
   iwf = SD.subseq{isubseq}.ipool;
   if iwf(1)==0, xL{iPlay} = [];
   else, 
      xL{iPlay} = getfield(SD.waveform{iwf(1)}.GENdata, fieldname);
   end
   if iwf(2)==0, xR{iPlay} = [];
   else, 
      xR{iPlay} = getfield(SD.waveform{iwf(2)}.GENdata, fieldname);
   end
   iPlay = iPlay + 1;
end




