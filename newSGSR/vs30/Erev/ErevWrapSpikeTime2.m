function E = ErevWrapSpikeTimes(spt, CycDur, Nbin, Nhan);
% input: relevant spiketimes, wrapped to 4*cycle dur


Edges = linspace(0,4*CycDur,Nbin+1);
E = histc(spt, Edges); E(end) = [];
if Nhan<0, return; end; % just bin
E = E/length(spt); % normalize
% smoothing
Nhan = 2*floor(Nhan/2)+1; % odd
if Nhan>1,
   hh = hanning(Nhan); hh = hh/sum(hh);
   E = conv([E,E,E],hh);
   E = E(Nbin+round(Nhan/2)-1+(1:Nbin));
end
% figure; plot(linspace(0,2,2*Nbin), [E, E]); uiwait(gcf);
twist = exp(i*linspace(0,2*pi,Nbin)); 
E = E.*twist;
% folding
E = reshape(E,Nbin/4,4).';
E = sum(E,1);
% E = E./twist(1:Nbin/4);

% smoothing
