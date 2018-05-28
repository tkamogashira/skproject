function OK = lastPlot(NewStyle, iback);
% lastplot - plots most recent sequence
if nargin<1 NewStyle=0;
else, NewStyle = isequal(upper(NewStyle),'N');
end
if nargin<2, iback=0; end;
if ischar(iback), iback=sscanf(iback,'%f'); end
FN = flipLR(strtok(flipLR(dataFile),'\'));

if NewStyle, sgsrplot(FN,currentSGSRIndex-iback-1);
else, spkplot(FN,currentIDFindex-iback-1);
end