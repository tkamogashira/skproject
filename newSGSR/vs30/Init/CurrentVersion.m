function CVstr = CurrentVersion;
% CurrentVersion - SGSR version number as string

global Versions
index = Versions.mostRecent;
CV = Versions.numbers(index);
CVstr = sprintf('%3.1f',CV);
% patches
ReleveantPatchIndices = find(abs(real(Versions.patches-CV))<1e-8); % ignore rounding errors
Patches = round(10*imag(Versions.patches(ReleveantPatchIndices)));
RP = max(Patches);
if ~isempty(RP),
   CVstr = [CVstr, num2str(RP)];
end
