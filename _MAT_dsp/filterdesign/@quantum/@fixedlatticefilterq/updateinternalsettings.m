function updateinternalsettings(q)
%UPDATEINTERNALSETTINGS   

%   Author(s): V. Pellissier
%   Copyright 1999-2003 The MathWorks, Inc.

if (isempty(q.privcoeffwl) || isempty(q.privcoefffl) || ...
      isempty(q.privstatewl) || isempty(q.privstatefl)),
  return;
end

% Define Product format and update fimath
[prodWL, prodFL] = set_prodq(q, q.privcoeffwl, q.privcoefffl, ...
    q.privstatewl, ...
    q.privstatefl);

% Define Accumulator format and update fimath
[accWL, accFL] = set_accq(q, prodWL, prodFL, q.ncoeffs);

% Define Output format
set_outq(q,accWL, accFL);


% [EOF]
