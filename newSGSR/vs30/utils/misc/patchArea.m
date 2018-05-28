function A = patchArea(h);
% PatchArea - area of a patch
%   PatchArea(h), where h is a handle of a patch, returns the oriented area
%   of the patch. By convention, left-handedly circumscribed patches have 
%   positive area.
%
%   see also PatchData, OnPatch.

Z = patchdata(h); % closed chain of vertices as complex numbers
Z = Z - mean(Z); % to minimize rounding errors
A = 0.5*imag((Z(1:end-1)'*Z(2:end)));



