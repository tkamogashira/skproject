function [CarTol, ModTol] = FreqTolerance(Fcar, Fmod, FreqTolMode);
% FreqTolerance - generic frequency tolerances for tonal stimuli
%   [CarTol, ModTol] = FreqTolerance(Fcar, Fmod, FreqTolMode) computes
%   tolerances for rounding of carrier freqency and modulation frequency.
%   Inputs are
%
%       Fcar: carrier frequency in Hz. Col array or Nx2 matrix, where rows
%             are conditions and columns are DA channels. Fcar is typically
%             computed by evalFrequencyStepper.
%    Fmod: modulation frequency in Hz. Also row or Nx2 matrix. 
%   FreqTolMode: one of 'exact' | 'economic' | 'fitting'. 
%             Decides whether roundings are allowed at all. In the 'exact'
%             mode, tolerances are zero. In the 'fitting' mode, tolerances
%             are put to inf, resulting in a rounding of the stimulus
%             frequency such that the burst duration will contain an
%             integer # samples (see CyclicStorage).
%
%   Outputs are
%    CarTol: When positive: maximum absolute value of the relative 
%            deviation between requested carrier frequency Fcar and 
%              realized carrier frequency FcarProx.
%            When zero: states that realized frequency must be exact; no
%              deviation is allowed.
%            When negative: minus the maximum total phase deviation in
%              cycles accumulated over the burst duration. (again, the 
%              deviation is evaluated as the difference between requested 
%              and realized situations).
%    ModTol: same as CarTol, but now for th modulation frequency.
%
%    The tolerances are determined for each and every element of Fcar and
%    Fmod according to the following rules.
%      0. when FreqTolMode is 'exact', CarTol=0 and ModTol=0.
%      1. when FreqTolMode is 'fitting', CarTol=0.05 and ModTol=0.05.
%      2. when only one channel is stimulated (ie, when both Fcar and Fmod 
%         are single row vectors), Cartol=0.0005, ModTol=0.01. That is, the
%         carrier frequency is accurate to 5 parts in 10,000 and the
%         modulation frequency is accurate to 1 part in 100.
%    The remaining rules only apply for binaural stimulation: either 
%    Fcar or Fmod, or both are Nx2 arrays.
%      3. when Fcar>5000 Hz, CarTol=0.0005.
%      4. When Fcar<5000 and the left and right channel are equal, i.e.,
%         Fcar(k,1)==Fcar(k,2), again CarTol=0.0005.
%      5. When all(Fcar(k,:)<5000) and there is a nonzero carrier beat, 
%         that is, Fbeat = diff(Fcar(k,:)) ~= 0, then 
%         CarTol(k,1) = CarTol(k,2) = -0.05. This ensures that over the
%         the total carrier beat phase accumulated over the tone duration 
%         does not deviate more than 10% from the true value.
%    Analogous rules apply to binaural modulation:
%      6. when Fmod>3000 Hz, ModTol=0.01.
%      7. When Fmod<3000 and the left and right channel are equal, i.e.
%         Fmod(k,1)==Fmod(k,2), again ModTol=0.01.
%      8. When all(Fmod(k,:)<5000) and there is a nonzero modulation beat, 
%         that is, Fmodbeat = diff(Fmod(k,:)) ~= 0, then 
%         ModTol(k,1) = ModTol(k,2) = -0.05. This ensures that over the
%         the total modulation beat phase accumulated over the tone duration 
%         does not deviate more than 10% from the true value.
%
%    Remark.
%     The limits Fcar=5000 Hz and Fmod=3000 Hz in the above are motivated
%     by the limits of phase locking in the auditory nerve.
%
%    See also see CyclicStorage.

% ensure same sizes
[Fcar, Fmod] = sameSize(Fcar, Fmod);
% phase locking limits
FcarMax = 5000; % Hz 
FmodMax = 3000; % Hz
% default tolerances used when no phase-locking beats occur (see help text)
defCarTol = 0.0005; defModTol = 0.01;

% apply the rules stated in help text
if isequal('exact', FreqTolMode), % zero tolerance (rule 1)
    CarTol = 0*Fcar; % correct size; all zeros
    ModTol = CarTol;
elseif isequal('fitting', FreqTolMode), % round period to 
    CarTol = inf*Fcar; % correct size; all inf
    ModTol = CarTol;
elseif isequal(1,size(Fcar,2)), % single channel: no beats (rule 2)
    CarTol = 0*Fcar + defCarTol; 
    ModTol = 0*Fmod + defModTol;
else, % treat each condition, and car and mod separately; 
    for ii=1:size(Fcar,1),
        % carrier
        fc = Fcar(ii,:);
        if all(fc>FcarMax), % no car phase locking (rule 3)
            CarTol(ii,1:2) = defCarTol;
        elseif fc(1)==fc(2), % no carrier beats (rule 4)
            CarTol(ii,1:2) = defCarTol;
        else, % carrier beats in phase locking regime (rule 5)
            CarTol(ii,1:2) = -0.05; % 0.05 cycle max cumulative phase error
        end
        % modulation
        fm = Fmod(ii,:);
        if all(fm>FmodMax), % no mod phase locking (rule 6)
            ModTol(ii,1:2) = defModTol;
        elseif fm(1)==fm(2), % no modulation beats (rule 7)
            ModTol(ii,1:2) = defModTol;
        else, % modulation beats in phase locking regime (rule 8)
            ModTol(ii,1:2) = -0.05; % 0.05 cycle max cumulative phase error
        end
    end
end

    
    
    
    
    
    