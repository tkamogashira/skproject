function ear = CDleftDACear;
%  CDleftDACear - leftDAC ear of current calib file, returns L/R/?
global CALIB
ear = getfieldordef(CALIB.ERC(1), 'LeftDACear', '?');

