function hc = copy(h)
%COPY  Copy adaptive filter object.
%	Hc = COPY(H) Produces an identical copy of the adaptive filter object H.	
%
%   See also RESET.



%   Author(s): R. Losada
%   Copyright 1999-2004 The MathWorks, Inc.

props = constructargs(h);

% Loop over the props and get them from the object.  If the output is not a
% string or its not a property assume that its the value.
for indx = 1:length(props),
    if ischar(props{indx}) && isprop(h, props{indx}),
        vals{indx} = get(h, props{indx});
    else
        vals{indx} = props{indx};
    end
end

% Construct the object.
hc = feval(str2func(class(h)),vals{:});

rbf = h.PersistentMemory;

hc.PersistentMemory = true;

% See whatever properties also need to be set.
props = props2copy(h);
if ~isempty(props),
    set(hc, props, get(h, props));
end

hc.PersistentMemory = rbf;

% Capture the state of the object so that we reset to this state.
capture(hc);
