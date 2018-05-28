function d = maddatadir
%MADDATADIR returns directory where madison datafiles are localized
%
%   See also DATADIR

%B. Van de Sande 04-07-2003
%Integratie van MADISON datafiles in SGSR

S = getdirinfo;
d = S.MadDataDir;

if ~exist(d, 'dir'), d = []; end