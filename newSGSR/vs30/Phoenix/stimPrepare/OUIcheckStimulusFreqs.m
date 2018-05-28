function OK = OUIcheckStimulusFreqs(S, ParNames);
% OUIcheckStimulusFreqs - check validity of stimulus frequencies among stimulus parameters

OK = 0;
ParNames = cellStr(ParNames); % length must give # names, not #chars

for ii=1:length(ParNames),
   par = getfield(S, ParNames{ii});
   [dum dum Mess] = safeSampleFreq(par.in_Hz);
   if OUIerror(Mess, par.name), return; end
end
   
OK = 1;