function resave_mdl
% RESAVE_MDL Utility function for DSP System Toolbox.
%   Opens, re-saves, then closes all MDL and SLX files in the current directory.

% Copyright 1995-2011 The MathWorks, Inc.

d=dir('*.mdl');
d1 = dir('*.slx');
d = [d; d1];
for i=1:length(d),
   name = d(i).name;
   open_system(name);
   close_system(name,1);  % save and close
end
