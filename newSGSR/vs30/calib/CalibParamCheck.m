function [OK, BWreg, Fhighest, highestBW, eh, maxSPL] = CalibParamCheck(hh);
% CalibParamCheck - read and check calibration parameters from calib menus
OK = 0;

eh = [hh.RegBWEdit hh.HighFreqEdit hh.HFbandwidthEdit];

BWreg = abs(UIdoubleFromStr(hh.RegBWEdit,1));
Fhighest = abs(UIdoubleFromStr(hh.HighFreqEdit,1));
highestBW = abs(UIdoubleFromStr(hh.HFbandwidthEdit,1));
if nargout>5,
   maxSPL = abs(UIdoubleFromStr(hh.MaxSPLEdit,1));
   eh = [eh hh.MaxSPLEdit];
else, maxSPL = 0;
end

     
if ~checkNanAndInf([BWreg, Fhighest, highestBW, maxSPL]), return; end;

if (BWreg<10), 
   UIerror('default BW may not be smaller than 10 Hz', hh.RegBWEdit);
elseif (highestBW<10), 
   UIerror('HF BW may not be smaller than 10 Hz', hh.RegBWEdit); 
else, 
   OK =1;
end;



