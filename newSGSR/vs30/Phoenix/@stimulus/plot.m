function plot(ST, id);
% stimulus/PLOT - PLOT for stimulus objects
%   Plot(ST, I) plots the waveform of the I-th DAshot in ST.
%   Repeated chunks are plotted in full, i.e., the repetitions
%   are implemented. Vertical grey lines indicate the limits of the 
%   different chunks of the waveforms. Left and right DA channels are
%   plotted in red and green, respectively. Attenuation is
%   incorporated in the plot.
%   
%   Plot(ST, -I) plots the waveform of the I-the DAshot without
%   the repetitions. 

clf;

repPlot = (id>0);
id = abs(id);

shot = ST.DAshot(id);

hw = shot.HardwareSettings;
Tsam = 1e3/hw.Fsam; % sample period in ms

ploco = [0.8 0 0; 0 0.5 0]; % plot colors
for ichan=1:2,
   Wav = shot.waveform(:,ichan);
   if isequal(0, Wav(1)), continue; end; % inactive DA channel
   % compute the samples by mixing the waveforms
   WF = 0;
   for iwav=1:length(Wav); % concatenate the chunks of the waveform
      weight = shot.weight(iwav, ichan);
      chunkList = ST.waveform(Wav(iwav)).chunkList;
      Nchunk = size(chunkList,1);
      wf = []; limits = [];
      for ichunk=1:Nchunk,
         chunkIndex = chunkList(ichunk,1);
         chunkRep = chunkList(ichunk,2);
         chunk = ST.chunk(chunkIndex).samples;
         lm = length(chunk);
         if repPlot, 
            chunk = repmat(chunk, chunkRep, 1); 
            lm = repmat(lm, chunkRep, 1); 
         end
         wf = [wf; chunk];
         limits = [limits; Tsam*lm];
      end % chunk loop
      WF = WF + weight*wf;
   end % waveform loop
   Nsam = length(WF);
   time = (0:Nsam-1)*Tsam;
   aScale = db2a(-hw.Atten(ichan));
   col = ploco(ichan,:);
   xplot(time, aScale*WF, 'color', col);
   % remember locations of chunk limits
   Limits{ichan} = cumsum(limits);
end % channel loop

% draw vertical dashed lines to seperate chunks
YL = ylim;
for ichan=1:2,
   Wav = shot.waveform(:,ichan);
   if isequal(0, Wav(1)), continue; end; % inactive DA channel
   limits = Limits{ichan};
   dumy = 0*limits;
   limits = vectorZip(limits, limits, limits);
   dumy = vectorZip(YL(1)+dumy, YL(2)+dumy, nan*dumy);
   xplot(limits, dumy, ':', 'color', ploco(ichan,:));
end

xlabel('Time (ms)');
ylabel('Amplitude');
title(['Attenuator: ' bracket(num2sstr(hw.Atten)) ' dB']);


