function varargout=nop(varargin)
% nop - do nothing but returning empty values
for ii=1:nargout
   varargout(ii)={[]};
end
