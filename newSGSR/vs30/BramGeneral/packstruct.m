function S = packstruct(varargin)
%PACKSTRUCT pack variables in structure
%   S = PACKSTRUCT(A, B, ...) packs variables A, B, ... in structure S with fieldnames A, B, ...
%   Instead of giving the variables itself, the name of these variables van be given as character
%   strings.
%
%   See also UNPACKSTRUCT

S = [];

for n = 1:nargin
   FName = inputname(n); 
   if ~isempty(FName), S = setfield(S, FName, varargin{n});
   else, 
       try S = setfield(S, varargin{n}, evalin('caller', varargin{n}));
       catch warning(sprintf('Input argument %s is not the name of a variable.', n)); end
   end
end    