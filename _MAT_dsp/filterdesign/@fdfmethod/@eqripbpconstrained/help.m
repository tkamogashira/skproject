function help(this)
%HELP   

%   Copyright 2011 The MathWorks, Inc.

help_equiripple(this);
help_densityfactor(this);
help_weight(this, 'Wstop1', 'Wpass', 'Wstop2');
fprintf(['    Note that if a band has been constrained, then its corresponding weight\n',...
         '    becomes irrelevant. If two bands are constrained, then all of the weights\n',...
         '    become irrelevant.\n\n'])
help_examples(this);

% [EOF]
