function PRL = CDcompPRL(fname, saveit);
% CDcompPRB - compute probe-loss trf from CAV & PRL; save it unless specified otherwise
if nargin<2, saveit = 1; end; % default: do save
if ischar(fname),
   CAV = CDread('CAV', fname);
   PRB = CDread('PRB', fname);
else, % calib data are in first arg
   CAV = fname{1};
   PRB = fname{2};
   saveit = 0; % no filename, no storage
end
if ~isequal(CAV.calibParams, PRB.calibParams),
   error('incompatible CAV and PRB data');
end
indivFields = {'ADC', 'Attenuator', 'MeasSPL', 'NoiseBackground'};
PRL = rmfield(CAV, indivFields);
PRL.filename = '';
PRL.CalType = 'PRL';
Nfilt = length(CAV.TRF);
for ifilt = 1:Nfilt,
   prb = PRB.TRF{ifilt}; 
   prb(find(prb==0)) = inf;
   PRL.TRF{ifilt} = CAV.TRF{ifilt}./prb;
end
% store indiv fields
cav = []; prb = [];
for ii=1:length(indivFields),
   fn = indivFields{ii};
   cav = setfield(cav, fn, getfield(CAV, fn));
   prb = setfield(prb, fn, getfield(PRB, fn));
end
PRL.CAV = cav;
PRL.PRB = prb;

if saveit,
   PRL.filename = CDwrite(PRL, fname);
end


