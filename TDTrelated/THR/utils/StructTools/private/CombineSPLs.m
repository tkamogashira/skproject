function SPL = CombineSPLs(varargin)
%COMBINESPLS   combine SPL given in dB 
%   SPL = COMBINESPLS(SPL1, SPL2, ...) returns the SPL in dB corresponding
%   with the average power of the given SPLs (in dB). SPL1, SPL2, ... can
%   be vectors of the same length.
%
%   SPL = COMBINESPLS(SPLm) where SPLm is a matrix, combines the spls along
%   the rows of SPLm and a vector with the same length as the number of rows
%   in SPLm is returned.

%B. Van de Sande 17-05-2004

if (nargin == 0), error('Wrong number of input arguments.');
elseif (nargin == 1), SPLs = varargin{1};
else,    
    Nrow = max(cellfun('length', varargin)); Ncol = nargin; 
    SPLs = zeros(Nrow, Ncol);
    for n = 1:Ncol, SPLs(:, n) = varargin{n}(:); end
end

SPL = p2db(mean(db2p(SPLs), 2));