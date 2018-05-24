function varargout = copyobj(varargin)
%COPYOBJ  Copy QFFT object.
%   F1 = COPYOBJ(F) makes a copy of QFFT object F and returns it in QFFT
%   object F1.
%
%   [F1,F2,...] = COPYOBJ(Fa,Fb,...) copies Fa into F1, Fb into F2, etc.  
%
%   [F1,F2,...] = COPYOBJ(F) makes multiple copies of the same object.
%
%   Example:
%     F = qfft('CoefficientFormat',[8 7]);
%     F1 = copyobj(F)
%
%   See also QFFT.

%   Thomas A. Bryan, 20 January 2000
%   Copyright 1999-2002 The MathWorks, Inc.


n=max(1,nargout);
if nargin>1 & n~=nargin
  error(message('dsp:qfft:copyobj:NARGCHK'))
end
for k=1:n
  varargout{k} = qfft(get(varargin{min(k,nargin)}));
end
