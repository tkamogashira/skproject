function [ifc, icc, FreqChoiceStr, ChanChoiceStr, defstr] = ExploreFcycle(ds);
% ExploreFcycle - evaluates standard frequencies for cycle histogram of given dataset

chan = ds.dachan; isbin = chan==0;
ichan = chan; if isequal(0,ichan), ichan = [1 2]; end;
fcar = binauralize(ds.fcar, chan, ds.Nsub); 
hascar = ~all(isnan(fcar(:, ichan)));
fmod = binauralize(ds.fmod, chan, ds.Nsub);
hasmod = ~all(isnan(fmod(:, ichan))) & ~all(fmod(:, ichan)==0);
fbeat = abs(diff(fcar,1,2)); % beat = diff between columns
hasbeat = ~all(isnan(fbeat(:))) & ~all(fbeat(:)==0) & isequal(0,chan);
fmodbeat = abs(diff(fmod,1,2)); % beat = diff between columns
hasmodbeat = ~all(isnan(fbeat(:))) & ~all(fmodbeat(:)==0) & isequal(0,chan);

FreqChoiceStr = {'other', 'carrier', 'modulation'};
ChanChoiceStr = {'beat', 'left', 'right', 'none'};

% 'other' option always avaliable, others depend on stimulus
ifc = [1 any(hascar), any(hasmod)]; 

% compute, for each freq choice, the possible channel options 
icOther = [0 0 0 1]'; % channel info irrelevant for manual freq
icCar = [hasbeat (chan~=2) (chan~=1) 0]';% given a carrier, these are the resp ch options
icMod = [hasmodbeat (chan~=2) (chan~=1) 0]'; % idem modulation

icc = [icOther icCar icMod]; % logical matrix containing the conditional availability
%    ... of channel options. Each column corresponds to a freq option in ifc.
% set to zero all icc entries that correspond to impossible freq
inofc = find(ifc==0);
if ~isempty(inofc), icc(:, inofc)=0; end


% find most binaural, most mod-like, and valid combination of button settings
imostBin = min(find(any(icc'))); % see order of ChanChoiceStr
imostMod = max(find(icc(imostBin,:)));
defstr = {FreqChoiceStr{imostMod} ChanChoiceStr{imostBin}};




