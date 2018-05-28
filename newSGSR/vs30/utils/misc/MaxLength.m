function ML = MaxLength(varargin)
% MaxLength - maximum length of input arguments
%    MaxLength(X,Y,..) equals max(length(X), length(Y), ...)

ML = 0;
for ii=1:nargin,
   ML = max(ML,length(varargin{ii}));
end









