function help_weights(~)
%HELP_WEIGHTS

%   Copyright 2011 The MathWorks, Inc.

w_str = sprintf('%s\n%s\n%s\n%s\n%s', ...
    '    HD = DESIGN(..., ''B1Weights'', WEIGHTS) uses the weights in WEIGHTS to',...
    '    weight the error of the first band in the design. Use the ''BiWeights''',...
    '    design option to specify weights for the i-th band. The ''BiWeights'' design',...
    '    option is only available when you specify the i-th band as an unconstrained',...
    '    band.');
    
disp(w_str);
disp(' ');


% [EOF]