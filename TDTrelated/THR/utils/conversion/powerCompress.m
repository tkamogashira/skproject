function varargout = powerCompress(alpha, varargin);
% PowerCompress - instantaneous power-law compression of waveforms
%    [X,Y,..] = powerCompress(Alpha, X,Y,...) applies instantaneous
%    compression to waveforms X,Y,.. . The compression 
%    follows a power law with exponent Alpha, that is, Alpha is the 
%    rate of growth in dB/dB of the of the I/O function.
%    The formula used is X -> sign(X).*abs(X).^Alpha.
%
%    Note that when Z is a complex analytic signal, powerCompress(Z) 
%    actually represents an "instantaneous gain control", because abs(Z)
%    is the envelope of Z in this case.
% 
%    See also Clip.

for iarg=1:nargin-1,
    X = varargin{iarg};
    varargout{iarg} = sign(X).*abs(X).^alpha;
end
    
    
    
    
    
    
    