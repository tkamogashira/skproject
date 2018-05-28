function RS = spikesToRap(FN, iSeq, chan, Xname, Yname, FlushFileFid);
% spikesToRap - converts spike times to rap format
if nargin<5, Yname = 'NONE'; end
if nargin<6, FlushFileFid=0; end;

IDF = idfget(FN, iSeq); 
Nrec = IDF.stimcntrl.max_subseq;
SPK = spkExtractSeq(FN, iSeq);
subi = SPK.subseqInfo;
Nsub = length(subi);
Nrep = size(SPK.spikeTime,2);
RS = '';
usualXval = 1;
if IDF.stimcntrl.stimtype==25, % NSPL: get var1values from IDF file
   [Flow, Fhigh, Rho, RandSeed, startSPL, endSPL, stepSPL] = extractNewNoiseParams(IDF);
   active = IDF.stimcntrl.activechan;
   [SPLsweepOK, SPL] = SPLsweepchecker(CollectInStruct(startSPL, stepSPL, endSPL, active), 0);
   varChan = idfLimitChan(IDF.stimcntrl.activechan, SPL);
   XVAL = SPL(:, varChan);
   usualXval = 0;
end

for isub=1:Nsub,
   if usualXval, xval = subi{isub}.var1(chan);
   else, xval=XVAL(isub);
   end
   yval = subi{isub}.var2(chan);
   RS = strvcat(RS, [' ' Xname ' : ' num2str(xval) '  ' Yname ' : ' num2str(yval)]);
   if isub<=Nrec,
      for irep=1:Nrep,
         RS = strvcat(RS, [' Rep # ' num2str(irep)]);
         Nsp = length(SPK.spikeTime{isub,irep});
         for ispk=1:Nsp,
            RS = strvcat(RS, ['   ' num2str(SPK.spikeTime{isub,irep}(ispk))]);
         end
         if FlushFileFid,
            textwrite(FlushFileFid, RS);
            RS = '';
         end
      end
   end
end
% final flush
if FlushFileFid,
   textwrite(FlushFileFid, RS);
   RS = '';
end

