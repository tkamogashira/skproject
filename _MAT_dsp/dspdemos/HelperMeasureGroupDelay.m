function gd = HelperMeasureGroupDelay(Txy, varargin)
%MEASUREGROUPDELAY Measures group delay from transfer function estimate
%   MEASUREGROUPDELAY(TXY) Measures group delay in sample time units for
%   the complex, single-sided transfer function estimate TXY using no
%   smoothing to attenuate effects due to divisions by small values of
%   real(TXY). TXY is either a column vector or a matrix. If TXY is
%   a matrix, then each column of TXY is treated as an independent transfer
%   function estimate and the group delay is measured along the columns of
%   TXY. If the number of rows of TXY is n, it is assumed that the
%   double-sided transfer function estimate has 2(n-1) frequency bins. This
%   is equivalent to considering that TXY is a single-sided spectrum
%   defined between 0 and the Nyquist frequency extremes included, and that
%   the corresponding time-domain frame has an even number of samples
%
%   MEASUREGROUPDELAY(TXY, FREQINCREMENT) manually defines the frequency
%   difference between two consecutive samples of TXY in
%   FREQINCREMENT. FREQINCREMENT is expressed in normalized angular
%   frequency, in units of pi rad/sample, with 1 corresponding to the
%   Nyquist frequency. The default value for FREQINCREMENT is equal to 
%   1/(size(TXY,1)-1)
%
%   MEASUREGROUPDELAY(TXY, FREQINCREMENT, SMOOTHFILTERORDER) applies a
%   median smoothing filter of order SMOOTHFILTERORDER to attenuate noisy
%   effects for small values of real(TXY).
%
%   See also ANGLE, GRPDELAY, MEDFILT1.
%
% Copyright 2013 The MathWorks, Inc.

persistent b del

% Half or whole spectrum in input?
if(nargin > 1)&&~isempty(varargin{1})
    frequencyIncrement = varargin{1};
else
    frequencyIncrement = 1/(size(Txy, 1)-1);
end

% Median filtering order for smoothing of phase derivative
if(nargin > 2)&&~isempty(varargin{2})
    smoothFiltOrder = varargin{2};
else
    smoothFiltOrder = 1;
end

% FIR filter coefficients for -d/dw
if(isempty(b))
    diffOrd = 44;  diffFPass = 0.3; diffFStop = 0.5;
    d = fdesign.differentiator('N,Fp,Fst', diffOrd, diffFPass, diffFStop);
    hDiff =  design(d, 'firls');
    b = -1/(frequencyIncrement*pi) * hDiff.Numerator;
    del = diffOrd/2;
end

% Measure group delay: unwrap, differentiate and smooth
ph = localUnwrap(angle(Txy),pi/2);
dph = filter(b, 1, [ph; ph(end:-1:end-del+1,:)]);
dph = dph(del+1:end,:);
gd = medfilt1(dph, smoothFiltOrder);


function p = localUnwrap(p, cutoff)

m = length(p);

dp = diff(p,1,1);                % Incremental phase variations
dps = mod(dp+pi,2*pi) - pi;      % Equivalent phase variations in [-pi,pi)
dps2 = mod(dps+pi/2,pi) - pi/2;  % Equivalent in [-pi/2,pi/2)
dps2(dps2==-pi & dp>0) = pi;     % Preserve variation sign for pi vs. -pi
dp_corr = dps2 - dp;             % Incremental phase corrections
dp_corr(abs(dp)<cutoff) = 0;     % Ignore for incr. variation is < CUTOFF

% Integrate corrections and add to P to produce smoothed phase values
p(2:m,:) = p(2:m,:) + cumsum(dp_corr,1);



