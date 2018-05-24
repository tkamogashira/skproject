%% SSB Modulation
% This example shows single sideband (SSB) modulation using
% sample-based and frame-based processing.
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('ssbdemo');
set_param('ssbdemo','StopTime','99');
sim('ssbdemo');
%%
bdclose ssbdemo

%% Available Example Versions
% All-platform sample-based version: <matlab:ssbdemo ssbdemo.mdl>
%
% All-platform frame-based version: <matlab:ssbdemo_frame ssbdemo_frame.mdl>
