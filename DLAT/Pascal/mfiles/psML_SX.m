% psMergeL_SX
% Merges DLAT created by psLATgen_DSACXAC and DSACXAC created by psSACXAC
% creates a field slope, which contains the slope-values of the delay vs intensity-curves as estimated by polyfit
% 
% TF 29/08/2005

echo on;

D = struct([]);

load psLATgen_all;
load psSACXAC;

%merge the two lists
D = structmerge(DLAT, {'ds1.filename', 'ds1.iseqp'}, DSACXAC, {'ds1.filename', 'ds1.iseq'});

%create the new field slope and its values
D(1).slope = NaN;
Args = num2cell(getTRatios(D));
[D.slope] = deal(Args{:});

%-----------------------------------------------------------------
DM = D; clear('D');
save(mfilename, 'DM');
%-----------------------------------------------------------------

echo off;