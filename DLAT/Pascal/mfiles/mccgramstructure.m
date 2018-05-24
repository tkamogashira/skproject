function output_correlogram = mccgramstructure(modelname, transduction, samplefreq, lowfreq, highfreq, filterdensity, nfilters,q, bwmin, mindelay, maxdelay, ndelays, typeswitch);
% function output_correlogram = 
% mccgramstructure(modelname, transduction, samplerate, 
%                  lowfreq, highfreq, filterdensity, 
%                  nfilters, q, bwmin, 
%                  mindelay, maxdelay, ndelays, typeswitch);
%
% -----------------------------------------------------------
% Fills a 'correlogram' structure with data and information.
% More information (data, cfs, delays) is filled in by
% mcorrelogram.m
%-----------------------------------------------------------
% 
% Input parameters:
%    modelname     = string with name of function that created correlogram
%    transduction  = string containing type of neural transduction
%    samplerate    = sampling rate (Hz)
%    lowfreq       = nominal lower freq of filterbank (Hz)
%    highfreq      = nominal lower freq of filterbank (Hz)
%    filterdensity = density of filters (filters per ERB)
%    nfilters      = number of filters
%    q             = q-factor of filters
%    bwmin         = bwmin-factor of filters
%    mindelay      = left-hand edge of delayaxis (usecs)
%    maxdelay      = left-hand edge of delayaxis (usecs)
%    ndelays       = number of delays
%    typeswitch    = 'binauralcorrelogram' or 'autocorrelogram'
%                    (used to set us or ms units in the plots)
% 
% Output parameters:
%    output_correlogram = correlogram structure
%
%
% See mcorrelogram.m for an example.
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


cc1.title = '';                 % title string
cc1.type = typeswitch;          % 'binauralcorrelogram' or 'autocorrelogram'
cc1.modelname = modelname;      % string with name of function that created correlogram
cc1.transduction = transduction;% string containing type of compression
cc1.samplefreq = samplefreq;    % sampling rate, Hz

cc1.mincf = lowfreq;            % nominal lower freq of filterbank, Hz
cc1.maxcf = highfreq;           % nominal upper freq of filterbank, Hz
cc1.density = filterdensity;    % density of filters, filters per ERB
cc1.nfilters = nfilters;        % number of filters
cc1.q = q;                      % q factor of filters; see mgammatonefilterbank
cc1.bwmin = bwmin;              % bwmin factor of filters; see mgammatonefilterbank

cc1.mindelay = mindelay;        % left-hand edge of delayaxis, usecs
cc1.maxdelay = maxdelay;        % right-hand edge of delayaxis, usecs
cc1.ndelays = ndelays;          % number of delays

cc1.freqaxishz = zeros(nfilters, 1); % 1xNf vector of filter center frequencies, Hz
cc1.freqaxiserb = zeros(nfilters, 1);% 1xNf vector of filter center frequencies, ERB number
cc1.powerleft = zeros(nfilters, 1);  % 1xNf vector of power in each channel, Hz
cc1.powerright = zeros(nfilters, 1); % 1xNf vector of power in each channel, Hz
cc1.delayaxis = zeros(1, ndelays);   % 1xNd vector of delay points, usecs

cc1.freqweight = 'null';         % string defining what frequency weighting was applied
cc1.delayweight = 'null';        % string defining what delay weighting (=p(tau)) was applied

cc1.data = zeros(nfilters, ndelays); % NfxNd matrix containing points in correlogram
   
   
% return values
output_correlogram = cc1;


   
% the end
%--------------------------------