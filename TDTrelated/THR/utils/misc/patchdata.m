function Z = patchdata(h);
% PatchData - Xdata and Ydata of a patch as complex numbers with first point repeated
%   PatchData(h), where h is a handle of a patch, returns a column vector 
%   Z = Xdata + i*Ydata, where Xdata and Ydata are the taken from the patch.
%   The first data point is appended to the Xdata and Ydata, so that 
%   first and last datapoints are equal.
%
%   see also Patch, PatchArea, OnPatch.

if ~isOneHandle(h), error('First argument must be graphics handle.'); end
if ~isequal('patch', get(h,'type')), error('Graphics handle must belong to a patch.'); end

if ~isempty(get(h, 'Zdata')), warning('Ignoring Zdata of patch.');
end
   
Z = get(h, 'Xdata') + i*get(h, 'Ydata');
% close the chain
if ~isempty(Z),
   if ~isequal(Z(1), Z(end)),
      Z = [Z; Z(1)];
   end
end




