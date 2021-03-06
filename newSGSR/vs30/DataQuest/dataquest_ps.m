%-----------------------------------------------------------------
%     DATAQUEST - Specific Parameters for PS datasets
%-----------------------------------------------------------------
function S = DataQuestSchema(ds)

%Check for dataset with newer version of the stimulus type and warn
%the user ...
VERSION = 1.0; VerFieldName = 'PSversion';
if ~isfield(ds.StimParam, VerFieldName), warning(sprintf('Failed to do version check on dataset %s.', ds.title));
elseif (getfield(ds.StimParam, VerFieldName) > VERSION), warning(sprintf('Dataset %s found that has newer version than script was intended for.', ds.title)); end

%Make sure the returned structure S always has the same fieldnames in
%the right order ...
Template = struct( ...
        'reps', NaN, ...
     'interval', NaN, ...
        'order', NaN, ...
     'burstDur', NaN, ...
      'riseDur', NaN, ...
      'fallDur', NaN, ...
          'SPL', NaN, ...
       'active', NaN, ...
       'Nphase', NaN, ...
         'freq', NaN, ...
    'PSversion', NaN);
S = structtemplate(ds.StimParam, Template, 'warning', 'off', 'reduction', 'off');

%-----------------------------------------------------------------