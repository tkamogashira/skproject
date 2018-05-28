function [RAPStat, LineNr, ErrTxt] = RAPCmdPL(RAPStat, LineNr, PlotType, OptArg)
%RAPCmdXXX  actual code for interpretation of RAP commandos
%   [RAPStat, LineNr, ErrTxt] = RAPCmdXXX(RAPStat, LineNr, Arg1, Arg2, ..., ArgN)
%
%   Attention! This function is an internal function belonging to the RAP 
%   project and should not be invoked from the MATLAB command prompt.

%B. Van de Sande 10-03-2004

%-------------------------------------RAP Syntax------------------------------------
%   PL TH			          Output Threshold (Tuning) curve plot directly to printer
%   PL SP [COUNT/RATE]        Output spike counts or rates vs. variable directly to printer
%   PL RAS                    Output dot raster directly to printer
%   PL SYNC		              Output Sync. Coeff. vs variable directly to printer
%   PL PHASE		          Output Phase vs. variables directly to printer
%   PL PST			          Output Post Stimulus Time Histograms directly to printer
%   PL ISI			          Output Inter-spike interval Histograms directly to printer
%   PL CH			          Output Cycle (or Phase) Histograms directly to printer
%   PL LAT 		       	      Output First Spiketime Latency Histograms directly to printer
%   PL SAC [COUNT/RATE/NORM]  Output Shuffled AutoCorrelation directly to printer
%   PL XC [COUNT/RATE/NORM]   Output CrossCorrelation directly to printer
%-----------------------------------------------------------------------------------

ErrTxt = 'PL command not yet implemented';