function  Z = SinMod(Z, Fsam, Ph0, Fmod, Depth, Theta);
% SinMod - sinusoidal modulation in time domain
%    Z = SinMod(Z, Fsam, Ph0, Fmod, Depth, ModPhase) applies a sinusoidal
%    modulation to waveform Z. Inputs are
%          Z: real or complex array to be modulated. Matrices are treated as
%             collections of column signals. For anything else than AM 
%             (see below), Z must be a complex analytic signal.
%       Fsam: sample rate of X in Hz.
%        Ph0: starting phase of modulation in cycles. Zero is cos phase.
%       Fmod: modulation frequency in Hz.
%      Depth: modulation depth in %. Default is 100%.
%      Theta: modulation angle in cycles. 0 means AM, 0.25 is QFM, other
%             values result in mixed modulation. Default is Theta = 0.
%             0 and 0.25 may be specified by char strings Theta = 'AM' 
%             and 'QFM', respectively.
%
%    Ph0, Fmode, Depth and Theta may all be row vectors, resulting in a
%    columnwize application of their elements. Their sizes and the number
%    of columns must be mutually compatible (i.e., each equals 1 or a
%    single M).
%
%    Stated in analog waveforms the expression for the modulated signal is
%  
%          z(t).*(1+0.01*Depth*e^(i*Theta)*cos(2*pi*(Ph0+Fmod)*t)),
%
%   See the Appendix of van der Heijden and Joris, JARO 2010.
%
%   See also 

[Depth, Theta] = arginDefaults('Depth/Theta', 100, 0); % 100 % AM modulation

if isequal('AM', Theta),      Theta = 0;
elseif isequal('QFM', Theta), Theta = 0.25;
end

[Z, wasRow] = TempColumnize(Z);

if rem(2*Theta,1)>0 && isreal(Z(:)),
    warning('Applying mixed modulation or QFM to a real signal.');
end

% sizes
error(local_checksize(Ph0, Fmod, Depth, Theta));
Nsig = size(Z,2);
[Ph0, Fmod, Depth, Theta] = sameSize(Ph0, Fmod, Depth, Theta, 1:Nsig);
if Nsig==1 && size(Ph0,2)>1,
    Z = Z*ones(1,Nsig);
end

% derived params
omega_m = 2*pi*Fmod/Fsam; % angular mod freq in rad/sample
m = Depth/100.*exp(2*pi*i*Theta); % percentage -> fraction -> complex depth
isam = (0:size(Z,1)-1).'; % sample counter, i.e. time axis in sample units
Phi0_rad = Ph0*2*pi; % starting phase in radians

% modulate columnwise
for icol = 1:Nsig,
    Z(:,icol) = Z(:,icol).*(1+m.*cos(Phi0_rad(icol) + omega_m(icol)*isam));
end

if wasRow, Z = Z.'; end

%==============
function Mess = local_checksize(varargin);
Mess = '';
for iarg=1:nargin
    if size(varargin{iarg},1)>1,
        Mess = [inputname(iarg) ' must be scalar or row vector.'];
        return;
    end
end



