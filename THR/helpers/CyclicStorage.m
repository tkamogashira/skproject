function S = CyclicStorage(Fcar, Fmod, Fsam, Dur, PhaseTol, NsamAllPres);
% CyclicStorage - evaluate cyclic storage of periodic waveform
%    S = CyclicStorage(Fcar, Fmod, Fsam, Dur, PhaseTol, NsamAllPres) evaluates 
%    the close approximation of a SAM tone by a repetition of a buffer 
%    containing a limited number of cycles. Fcar is the carrier frequency 
%    in Hz; Fmod the modulation frequency in Hz; Fsam the sample rate in 
%    Hz; Dur the total duration in ms. Unmodulated tones are specified 
%    by Fmod==0. PhaseTol is the maximum absolute cumulative phase deviation
%    of the carrier and modulator (default: 0.02 cycle each). To use
%    different tolerances for carrier and modulator, specify a pair
%    [CarTol ModTol].
%    NsamAllPres is the total #samples of all presentations of a recording. 
%    When NsamAllPres<5e5, the advice CyclesDoHelp (see below) is always
%    negative.
%
%    CyclicStorage returns a struct S containing the fields
%             CyclesDoHelp: advice (1 or 0) whether to use cyclic storage
%                     Fcar: equal to input Fcar
%                     Fmod: equal to input Fmod
%                     Fsam: equal to input  Fsam
%                      Dur: equal to input Dur
%                   CarTol: equal to input CarTol(1)
%                   ModTol: equal to input CarTol(end)
%              NsamAllPres: equal to input NsamAllPres
%     b___________________: '________________'
%              NSamLiteral: # samples of this presentation when stored literally
%                     Nsam: # samples to be stored in cycled mode
%                  Ncarcyc: # carrier cycles in the cycle buffer
%                  Nmodcyc: # modulation cycles in the cycle buffer
%                 NsamTail: # samples in the tail buffer
%        StoragePercentage: 100*Nsam/NtotSam
%     c___________________: '________________'
%                 FcarProx: modified Fcar to allow cycled storage
%                RelCarDev: relative deviation of Fcar
%           CumCarCycleDev: total cumulative carrier phase deviation [cycles] over dur
%                 FmodProx: modified Fmod to allow cycled storage
%                RelModDev: relative deviation of Fmod
%           CumModCycleDev: total cumulative modulation phase deviation [cycles] over dur
%
%    See also toneStim.

NSAMBIG = 5e5; % only consider cyclic storage if the total # samples over all presentations exceeds this value

if nargin<5, PhaseTol=[]; end
if nargin<6, NsamAllPres= inf; end % assume cyclic storage is needed

if isempty(PhaseTol), PhaseTol=0.02; end

CarTol = PhaseTol(1);
ModTol = PhaseTol(end);
NSamLiteral = round(Fsam*Dur*1e-3);
NtotCarCyc = Fcar*Dur*1e-3;
NtotModCyc = Fmod*Dur*1e-3;
Gcar = Fcar/Fsam; % normalized carrier freq
Gmod = Fmod/Fsam; % normalized modulation freq

% get relative measures of tolerance
if CarTol<0, % CarTol means max abs cumulative phase dev
    RelCarTol = abs(CarTol)/NtotCarCyc; % maximum relative deviation of car freq
else, % CarTol means relative dev; no conversion needed
    RelCarTol = CarTol; % maximum relative deviation of car freq
end
if ModTol<0, % ModTol means max abs cumulative phase dev
    RelModTol = abs(ModTol)/NtotModCyc; % maximum relative deviation of mod freq
else, % CarTol means relative dev; no conversion needed
    RelModTol = ModTol; % maximum relative deviation of mod freq
end
% absolute tolerances of normalized carrier & modulation frequencies
AbsCarTol = RelCarTol*Gcar;
AbsModTol = RelModTol*Gmod;

% Find smallest integer triple (Nsam, Ncarcyc, Nmodcyc) for which
%         Ncarcyc/Nsam ~ Gcar  
%    and  Nmodcyc/Nsam ~ Gmod    
% within the specified tolerances. Use brute force computation: try all
% reasonable values for Ncarcyc and the corresponding best values for Nsam
% and Nmodcyc.
nc = 1:ceil(NtotCarCyc/2); % no need to take Ncarcyc>0.5*Ntotcarcyc, because storage will not be cheaper than literal storage
ns = round(nc/Gcar); % corresponding Nsam approx
FcarProx = Fcar; % default "approximimation": exact value
FmodProx = Fmod; % idem fmod
if isequal(0,Gmod),
    igood = find(abs(nc./ns-Gcar)<=AbsCarTol, 1, 'first'); % smallest nc meeting the tolerance
    Ncarcyc = nc(igood);
    Nsam = ns(igood);
    if ~isempty(igood), FcarProx = Fsam*Ncarcyc/Nsam; end
    RelCarDev = (FcarProx-Fcar)/Fcar;
    CumCarCycleDev = (FcarProx-Fcar)*Dur*1e-3;
    Nmodcyc = 0; FmodProx = 0;
    RelModDev = 0; CumModCycleDev = 0;
else, % both Fcar and Fmod must be matched within tolerances
    nm = round(ns*Gmod); % corresponding Nmod approx
    igood = find((abs(nc./ns-Gcar)<=AbsCarTol) ...
        & (abs(nm./ns-Gmod)<=AbsModTol), 1, 'first'); % smallest nc meeting the tolerances
    Ncarcyc = nc(igood);
    Nmodcyc = nm(igood);
    Nsam = ns(igood);
    if ~isempty(igood), FcarProx = Fsam*Ncarcyc/Nsam; end
    RelCarDev = (FcarProx-Fcar)/Fcar;
    CumCarCycleDev = (FcarProx-Fcar)*Dur*1e-3;
    if ~isempty(igood), FmodProx = Fsam*Nmodcyc/Nsam; end
    RelModDev = (FmodProx-Fmod)/Fmod;
    CumModCycleDev = (FmodProx-Fmod)*Dur*1e-3;
end
NsamTail = rem(NSamLiteral, Nsam); % # samples to be played out of tail buffer
CyclesDoHelp = ~isempty(igood) && (NsamAllPres>NSAMBIG);
StoragePercentage = 100*(Nsam+NsamTail)/NSamLiteral;
S = collectInStruct(CyclesDoHelp, ...
    '-', Fcar, Fmod, Fsam, Dur, CarTol, ModTol, NsamAllPres, ...
    '-', NSamLiteral, Nsam, Ncarcyc, Nmodcyc, NsamTail, StoragePercentage, ...
    '-', FcarProx, RelCarDev, CumCarCycleDev, FmodProx, RelModDev, CumModCycleDev);







