function y = filter(Hm,x,dim)
%FILTER Filter method for multirate/multistage cascades.
%   Y = FILTER(Hm,X,DIM) filters data X over dimension DIM and returns
%   output Y.
%
%   See also DFILT.   
  
%   Author: V. Pellissier
%   Copyright 1999-2011 The MathWorks, Inc.
  
error(nargchk(1,3,nargin,'struct'));

if nargin<2, x = []; end
if nargin<3, dim = []; end

if isempty(x), 
  y = x;
  return; 
end

y = x;
flagdiff = false;
% Get current value of reset states
resetval = Hm.PersistentMemory;
if ~resetval,
    reset(Hm);
end

for k=1:length(Hm.Stage)
    if Hm.Stage(k).PersistentMemory~=resetval,
        Hm.Stage(k).PersistentMemory = resetval;
        flagdiff = true;
    end
    y = filter(Hm.Stage(k),y,dim);
end

if flagdiff,
     warning(message('dsp:mfilt:cascade:filter:flagInconsistency', mat2str( resetval )));
end

Hm.NumSamplesProcessed = Hm.NumSamplesProcessed+length(x);

