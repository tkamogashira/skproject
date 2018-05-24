function dspparameqflt2fixPrep()
%dspparameqflt2fixPrep
%   Prepares data types in demo model dspparameqflt2fix for conversion to
%   fixed point using the Fixed Point Advisor.
%
%   Copyright 2009 The MathWorks, Inc.


model = 'dspparameqflt2fix';

fprintf('Preparing model %s/Equalizer for conversion to fixed point:\n', model);

prepBiquadFilters(model, 'Band 1 ', 'DF1');
prepBiquadFilters(model, 'Band 2 ', 'DF2');
prepBiquadFilters(model, 'Band 3 ', 'DF2T');

disp('Changed Biquad Filter data types to ''Binary point scaling''.');
disp('Also set Biquad Filter accumulator word length to 40 bits.');

end

function prepBiquadFilters(model, subsystem, filter)
newParamSetting = 'Binary point scaling';

set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'accumMode', newParamSetting);
set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'accumWordLength', '40');
set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'prodOutputMode', newParamSetting);
set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'outputMode', newParamSetting);
set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'stageInputMode', newParamSetting);
set_param(sprintf('%s/Equalizer/%s\n%s/Biquad Filter',...
    model, subsystem, filter), 'stageOutputMode', newParamSetting);
end
