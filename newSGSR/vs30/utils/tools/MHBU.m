function MHBU(Ndays);
% MHBU - Marcel's backup utility: SGSR sources, documents, MLsig sources
% 
%   See also devBU, docBU, MLsigBU.

more off;
if nargin<1, Ndays=7; end;
devBU(Ndays);
docBU(Ndays);
MLSIGBU(Ndays);
dataBU(Ndays);
more on



