function [S, S2] = NoiseSpec(Fsam, Dur, RSeed, Cutoffs, SPL, SPLUnit, Rho);
% NoiseSpec - generate spectral noise buffer
%    S = NoiseSpec(Fsam, Dur, RSeed, Freq, SPL, SPLUnit, Rho)
%    returns struct S with fields
%
%      Fsam, Dur, RSeed, Cutoffs, SPL, SPLUnit, Rho: input args. Rho is
%            correlation between the noise buffer and the one returned with
%            Rho=1. Default Rho = 1.
%              totSPL: total SPL of noise
%             specSPL: spectrum level of noise
%      MinNoiseBufLen: minimum buffer length (ms). Hardcoded 3000 ms.
%                  dt: sample period (ms)
%              BufDur: buffer duration (ms); multiple of MinNoiseBufLen
%                  df: spectral spacing
%                Freq: frequency (Hz) per buffer component
%                 Buf: complex noise buffer
%
%

Rho = arginDefaults('Rho', 1);

if ~isequal(1, Rho), % realize Rho by mixing two indep buffers
    [RSeed, Nmax] = setRandState(RSeed);
    RSeed2 = rem(RSeed+31^2, Nmax);
    S = NoiseSpec(Fsam, Dur, RSeed, Cutoffs, SPL, SPLUnit);
    S2 = NoiseSpec(Fsam, Dur, RSeed2, Cutoffs, SPL, SPLUnit);
    S.Buf = Rho*S.Buf + sqrt(1-Rho.^2)*S2.Buf;
    return;
end

[SPLUnit, Mess] = keywordMatch(SPLUnit, {'dB SPL', 'dB/Hz'}, 'SPL type spec');
error(Mess);

if diff(Cutoffs)<0, error('Negative noise bandwidth'); end

MinNoiseBufLen = 3000; % min dur [ms] of noise buffer
Nblock = ceil(Dur/MinNoiseBufLen);
BufDur = round(Nblock*MinNoiseBufLen);
df = 1e3/BufDur; % freq spacing in Hz
Nsam = round(BufDur*Fsam*1e-3);
dt = 1e3/Fsam;

% generate wideband noise spectrum with each component having an RMS of 1
RSeed = setRandState(RSeed);
Buf = Nsam*randn(Nsam,2)*[1; i]; % the factor Nsam anticipates real(ifft(Buf)) as time waveform
Buf(1) = Buf(1)/2; % compensate for doubling the DC
Freq = Xaxis(Buf,df);

% determine passband cmps
qpass = betwixt(Freq, Cutoffs(:).'+[0 0.001]);
if ~any(qpass), % make sure there's at least one nonzero cmp
    [dum, ihit] = min(abs(mean(Cutoffs)-Freq));
    qpass(ihit) = true;
end
Nnonzero = sum(qpass); % # nonzero components

% evaluate amplitude per comp that realizes SPL specs
BW = diff(Cutoffs);
if isequal('dB SPL', SPLUnit), % convert total SPL to SPL of each comp
    SPL = SPL - p2db(Nnonzero);
elseif isequal('dB/Hz', SPLUnit), % "SPL/Hz" to "SPL/cmp"
    BW = max(BW, df);
    SPL = SPL + p2db(BW/Nnonzero);
end
totSPL = SPL+p2db(Nnonzero);
specSPL = totSPL-p2db(BW);
% apply spectral gating & scaling
Buf(~qpass) = 0;
Buf(qpass) = db2a(SPL) * Buf(qpass);

S = collectInStruct(Fsam, Dur, RSeed, Cutoffs, SPL, SPLUnit, '-', ...
    totSPL, specSPL, MinNoiseBufLen, dt, BufDur, df, '-', ...
    Freq, Buf);










