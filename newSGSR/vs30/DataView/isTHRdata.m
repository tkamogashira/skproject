function it = isTHRdata(ds)
% isTHRdata - returns 1 if dataset contains threshold data
%   Note: current threshold data types are:
%         THR (SGSR) and TH (EDF) are

it = ismember(upper(ds.stimtype), {'THR' 'TH'});
