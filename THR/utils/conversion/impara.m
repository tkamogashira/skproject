function Z=impara(varargin);
% impara - impedance of parallel impedances
%   impara(Z1, Z2, ..) returns the impedance resulting from a parallel
%   connection of indivividual impedances Z1, Z2, etc.
%   Z1,Z2, .. may be arrays of compatible sizes.
%

[varargin{:}] = samesize(varargin{:});
Z = 0;
for ii=1:nargin,
    Z = Z + 1./varargin{ii};
end
Z = 1./Z;




