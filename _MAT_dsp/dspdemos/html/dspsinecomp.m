%% Sine Wave Generation
% This example compares different sine wave generation methods in
% Simulink(R).
%%

% Copyright 2005-2012 The MathWorks, Inc.

open_system('dspsinecomp');
set_param('dspsinecomp','StopTime','0.1');
sim('dspsinecomp');
%%
bdclose dspsinecomp

%% Available Example Versions
% Sample-based version: <matlab:dspsinecomp dspsinecomp.mdl>
%
% Frame-based version: <matlab:dspsinecomp_frame dspsinecomp_frame.mdl>
