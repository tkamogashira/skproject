function disp(F)
%DISP   Display QFFT object. 
%   DISP(F) displays a QFFT object in the same way as leaving off the
%   semicolon, except that the name of the variable is not displayed.
%
%   Example:
%     F = qfft;
%     disp(F)
%
%   See also QFFT, QFFT/DISPLAY.

%   Thomas A. Bryan
%   Copyright 1999-2011 The MathWorks, Inc.

len = length(F);
scalevalues = F.scalevalues;

disp(['             Radix = ',num2str(radix(F))])
disp(['            Length = ',num2str(length(F))])
disp([' CoefficientFormat = ',tostring(coefficientformat(F))])
disp(['       InputFormat = ',tostring(inputformat(F))])
disp(['      OutputFormat = ',tostring(outputformat(F))])
disp(['MultiplicandFormat = ',tostring(multiplicandformat(F))])
disp(['     ProductFormat = ',tostring(productformat(F))])
disp(['         SumFormat = ',tostring(sumformat(F))])
disp(['  NumberOfSections = ',num2str(numberofsections(F))])
disp(['       ScaleValues = [',num2str(scalevalues),']'])

[msgObj] = lengthcheck(F,len);
if ~isempty(msgObj),
    warning(msgObj);
end
[msgObj] = scalevaluescheck(F,scalevalues);
if ~isempty(msgObj),
    warning(msgObj);
end
