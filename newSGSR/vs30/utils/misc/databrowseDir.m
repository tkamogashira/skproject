function sd=databrowsedir;
% SETUPDIR - returns setup directory as char string

global DEFDIRS
sd = [DEFDIRS.DataBrowse];

% if non-existing, make it
if ~exist(sd,'dir'),
   [Parent fff] = fileparts(sd);
   mkdir(Parent, fff);
end
