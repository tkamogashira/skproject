% SGSR version 1.1 patch 04 declaration file - Oct 11, 2001
% - fixed SS1switching call in AcoustSenseGo
% - D/A in PRB is now channel specific, not diotic
% - changed renderer mode of calibplot figure back to auto
% - included flat.erc
%
% cumulative patch

global Versions
Versions.patches = [Versions.patches, 1.1 + i*0.1*(1:4)];
