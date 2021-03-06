%-----------------------------------------------------------------
%       DATAQUEST - Specific Parameters for BN datasets
%-----------------------------------------------------------------
function S = DataQuestSchema(ds)

%Check for dataset with newer version of the stimulus type and warn
%the user ...
VERSION = 12.0; VerFieldName = 'BNversion';
if ~isfield(ds.StimParam, VerFieldName), warning(sprintf('Failed to do version check on dataset %s.', ds.title));
elseif (getfield(ds.StimParam, VerFieldName) > VERSION), warning(sprintf('Dataset %s found that has newer version than script was intended for.', ds.title)); end

%Make sure the returned structure S always has the same fieldnames in
%the right order ...
Template = struct( ...
    'SPL', NaN, ...
    'active', NaN, ...
    'Rseed', NaN, ...
    'TotDur', NaN, ...
    'MidFreq', NaN, ...
    'DDfreq', NaN, ...
    'MeanSepa', NaN, ...
    'Ncomp', NaN, ...
    'Tilt', NaN, ...
    'TiltStr', '', ...
    'order', NaN, ...
    'NoiseCutoff', NaN, ...
    'NoiseSPL', NaN, ...
    'NoiseEar', NaN, ...
    'RampDur', NaN, ...
    'BNversion', NaN);      
S = structtemplate(ds.StimParam, Template, 'warning', 'off', 'reduction', 'off');
      
%-----------------------------------------------------------------