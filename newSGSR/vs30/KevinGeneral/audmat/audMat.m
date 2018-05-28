% Audstuff for Matlab is a collection of functions to facilitate
% working with data collected in the Auditory Lab (i.e. data in EDF format)
% The following functions are available at present:
%
%    AudAutoCS              Compute Auto-Correlation Histogram
%    AudCrossCS             Compute Cross-Coreelation Histogram
%    audfileformat          Determine format of specified file
%    AudFiltPar2            Get stimulus Filter Params (CF/BW)
%    AudFiltTyp             Get stimulus Filter Type (e.g KLATT)
%    AudFixFreqSPL2         Get the Fixed Freq and SPL from data header
%    AudGetStats            Get table of statistics
%    AudGetTH               Get Tuning (Threshold) Curve
%    AudGWPar2              Get params for GW stimulus waveform
%    AudNextDSID            Get next Data Set ID from file
%    AudReadGW              Get General Waveform from a GW format dataset
%    AudRgl                 Regularity Analysis
%    AudRyCoff              Compute Rayleigh Coefficient
%    AudSACH                Computer Shuffled Auto-Correlation Hostogram
%    AudSpkTimes            Get Spike Times for any stimulus point
%    AudStimGW              Get stimulus-type and GWID
%    AudVarNames            Get stim-Variable names and Expt. Type
%    AudVarRange2           Get number of stim variables and their range
%
% To get more help about any of the above functions, just type the name
% of the function without any arguments, e.g.
%
%    >> audspktimes                  
%
% to get help about the AudSpkTimes function.
%
% Note that (on Windows or VMS) the function names are not case-sensitive
% thus audspktimes and AudSpkTimes work the same.

fprintf(' Audstuff for Matlab is a collection of functions to facilitate\n');
fprintf(' working with data collected in the Auditory Lab (i.e. data in EDF format)\n');
fprintf(' The following functions are available at present:\n\n');
fprintf('   AudAutoCS              Compute Auto-Correlation Histogram\n');
fprintf('   AudCrossCS             Compute Cross-Correlation Histogram\n');
fprintf('   audfileformat          Determine format of specified file\n');
fprintf('   AudFiltPar2            Get stimulus Filter params (CF/BW)\n');
fprintf('   AudFiltTyp             Get stimulus Filter Type (e.g. KLATT)\n');
fprintf('   AudFixFreqSPL2         Get the Fixed Freq and SPL from data header\n');
fprintf('   AudGetStats            Get table of statistics\n');
fprintf('   AudGetTH               Get Tuning (Threshold) Curve\n');
fprintf('   AudGWPar2              Get params for GW stimulus waveform\n');
fprintf('   AudNextDSID            Get next Data Set ID from file\n');
fprintf('   AudReadGW              Get General Waveform from a GW format dataset\n');
fprintf('   AudRgl                 Regularity Analysis\n');
fprintf('   AudRyCoff              Compute Rayleigh Coefficient\n');
fprintf('   AudSACH                Compute Shuffled Auto-Correlation Histogram\n');
fprintf('   AudSpkTimes            Get Spike Times for any stimulus point\n');
fprintf('   AudStimGW              Get stimulus-type and GWID\n');
fprintf('   AudVarNames            Get stim-Variable names and Expt. Type\n');
fprintf('   AudVarRange2           Get number of stim variables and their range\n\n');
fprintf(' To get more help about any of the above functions, just type the name\n');
fprintf(' of the function without any arguments, e.g.\n\n');
fprintf('   >> audspktimes\n\n');
fprintf(' to get help about the AudSpkTimes function.\n\n');
fprintf(' Note that (on Windows or VMS) the function names are not case-sensitive\n');
fprintf(' thus audspktimes and AudSpkTimes work the same.\n');
