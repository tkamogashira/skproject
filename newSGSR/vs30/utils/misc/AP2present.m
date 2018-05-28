function ip=AP2present;
% AP2present - returns 1 if AP2 is installed in this computer
%   AP2present uses presence of [setupdir NoAP2.SGSRsetup] file 
%   return 0.
global SGSR
ip = SGSR.TDTpresent;

