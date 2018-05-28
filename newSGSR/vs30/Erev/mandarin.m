function PDS = mandarin(FN, iSeq, cDelay, LimDelay, Nsig);
% mandarin - exhaustive analysis of BN data

AnCar = (cDelay<0);

cDelay = abs(cDelay);

dlbanana(cDelay, LimDelay, Nsig);
RC = banana(FN, iSeq);
if AnCar,
   [plotFreq, trfPH, isSign, carAmp] = orange;
   for jj=1:length(trfPH),
      RC{jj}.CarPhase = trfPH{jj}/2/pi;
      RC{jj}.CarIsSign = isSign{jj};
   end
end

PDS.Seq = RC;
PDS.cDelay = cDelay;
PDS.Nsig = Nsig;