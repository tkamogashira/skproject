function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if (isempty(q.privcoeffwl) || isempty(q.privcoefffl) || ...
      isempty(q.privcoefffl2) || ...
      isempty(q.privstatewl) || isempty(q.privstatefl)),
  return;
end

% Define Lattice Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privstatewl, ...
    q.privstatefl);

% Define Lattice Accumulator format and update fimath
set_accq(q, prodWL, prodFL, q.ncoeffs(1));

% Define Ladder Product format and update fimath
[prodWL, prodFL] = set_ladprodq(q, q.privcoeffwl, q.privcoefffl2, ...
    q.privstatewl, ...
    q.privstatefl);

% Define Ladder Accumulator format and update fimath
if length(q.ncoeffs)==2,
    [accWL, accFL] = set_ladaccq(q, prodWL, prodFL, q.ncoeffs(2));
    
    % Define Output format
    set_outq(q,accWL, accFL);
end

% [EOF]
