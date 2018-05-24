function null = msaveccdisplay(filename, correlogram, variablename)
% function null = 
% msaveccdisplay(filename, correlogram, variablename)
%
%-------------------------------------------------------------------
% Saves a correlogram in a format that can be read by ccdisplay.exe
%-------------------------------------------------------------------
%
% Input parameters:
%    filename     = where the saved data goes
%    correlogram  = structure as defined in mccgramcreate.m
%    variablename = name of data (eg cc1; saved in output file)
%
% Output parameters:
%    none
%
% Example:
% to save the previously-made correlogram 'cc1' in the file
% 'correlogram1.bcc' and give the variable the name '#1', type:
% >> msaveccdisplay('correlogram1.bcc', cc1, '#1');
%
% See mcallccdisplay.m for another example.
%
%
% version 1.0 (Jan 20th 2001)
% MAA Winter 2001 
%----------------------------------------------------------------

% ******************************************************************
% This MATLAB software was developed by Michael A Akeroyd for 
% supporting research at the University of Connecticut
% and the University of Sussex.  It is made available
% in the hope that it may prove useful. 
% 
% Any for-profit use or redistribution is prohibited. No warranty
% is expressed or implied. All rights reserved.
% 
%    Contact address:
%      Dr Michael A Akeroyd,
%      Laboratory of Experimental Psychology, 
%      University of Sussex, 
%      Falmer, 
%      Brighton, BN1 9QG, 
%      United Kingdom.
%    email:   maa@biols.susx.ac.uk 
%    webpage: http://www.biols.susx.ac.uk/Home/Michael_Akeroyd/
%  
% ******************************************************************
   
 
timeid = clock;


% save header ...
fprintf('writing header to %s ...\n', filename);
fid = fopen(filename, 'w');

% this version saves the centerfreqs direct in the correlogram
fprintf('(including filter center frequencies in output file)\n');
%dencf=0;                               

% write the header
fprintf(fid, '#header for ccdisplay file\n');
fprintf(fid, '#matlabname=%s\n', variablename);
fprintf(fid, '#title=%s\n', correlogram.title);
fprintf(fid, '#model=%s\n', correlogram.modelname);
fprintf(fid, '#compression=%s\n', correlogram.transduction);
fprintf(fid, '#freqweight=%s\n', correlogram.freqweight);
fprintf(fid, '#delayweight=%s\n', correlogram.delayweight);
fprintf(fid, '#frequencychannels=%d\n', correlogram.nfilters);
fprintf(fid, '#filterbankcontrol=correlogramindex\n');
fprintf(fid, '#mincf=%.2f\n', correlogram.mincf);
fprintf(fid, '#maxcf=%.2f\n', correlogram.maxcf);
fprintf(fid, '#dencf=%.1f\n', correlogram.density);
fprintf(fid, '#quality=%.5f\n', correlogram.q);
fprintf(fid, '#bwmin=%.5f\n', correlogram.bwmin);
fprintf(fid, '#delaystart_ms=%.3f\n', correlogram.mindelay/1000); % ms not us
fprintf(fid, '#delaystop_ms=%.3f\n', correlogram.maxdelay/1000);  % ditto
fprintf(fid, '#delaysamples=%.3f\n', correlogram.ndelays);
fprintf(fid, '#samplerate=%.0f\n', correlogram.samplefreq);
fprintf(fid, '#date=%dd-%dm-%dy\n', timeid(3), timeid(2), timeid(1));
fprintf(fid, '#time=%dh:%dm:%.0fs\n', timeid(4), timeid(5), timeid(6));
fprintf(fid, '#format=dos\n');
fprintf(fid, '#header created by %s\n', mfilename);
fprintf(fid','#end\n');


% create a (nfilters+1)x(ndelays) array for saving the data and 
% freq axis in
ccdata = zeros(correlogram.nfilters, correlogram.ndelays+1);
% fill the first column with the frequencies in Hz
ccdata(:,1) = correlogram.freqaxishz;
% fill the rest with the data
ccdata(1:correlogram.nfilters , 2:correlogram.ndelays+1) = correlogram.data;

fprintf('writing %dx%d data points to %s ...\n', correlogram.nfilters, correlogram.ndelays, filename);
fwrite(fid, ccdata, 'float32');
fclose(fid);

fprintf('\n');


% the end!
%------------------------------------------------------------
