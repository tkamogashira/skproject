function [Flow, Fhigh, Rho, RandSeed, startSPL, endSPL, stepSPL, noiseSign] = extractNewNoiseParams(IDFseq);
% extractNewNoiseParams - extract noise params "hidden" in noise IDFseq

%---------------- CHANGELOG -----------------------
% date          developer       short description
% 02/12/2010    Abel            stepSPL was not set for SN,'ntd' with
% newStyle data and ~newStyle data.

SN = idfstimname(IDFseq.stimcntrl.stimtype);
s1 = IDFseq.indiv.stim{1};
s2 = IDFseq.indiv.stim{2};
newmark = trimspace(s2.noise_data_set);
if isequal(SN,'ntd'),
   newStyle = isequal(newmark, 'NTD_RHO');
elseif isequal(SN,'nspl'),
   newStyle = isequal(newmark, 'NSPL_RHO');
else, error('not an NTD or NSPL IDFseq');
end


if ~newStyle, % default or fake values
   Flow = 10;
   Fhigh = s1.cutoff_freq;
   Rho = 1;
   RandSeed = 0;
   if isequal(SN,'ntd'),
       %By abel, set fake startSPL
       startSPL = nan;
   elseif isequal(SN,'nspl'),
      startSPL = 110-[s1.loattn s2.loattn];
      endSPL = 110-[s1.hiattn s2.hiattn];
      stepSPL = [s1.delattn s2.delattn];
      noiseSign = 1;
   end
   return
end

% see NSPLcreateIDF for the exotic way some of the following parameters ..
% .. are stored in idfSeq
RandSeed = StrToSeed(s2.file_name(6:10));
Flow = s1.sample_rate;
Fhigh = s1.cutoff_freq;
Rho = s2.sample_rate;

if isequal(SN, 'ntd')
    %By abel, set startSPL in case of NTD StimType
    startSPL = [s1.total_pts s2.total_pts];
elseif isequal(SN,'nspl'),
   % get SPLs from 'improper' fields of IdfSeq (see NSPLcreateIDF)
   startSPL = [s1.total_pts s2.total_pts];
   endSPL = startSPL + [s1.hiattn s2.hiattn] - [s1.loattn s2.loattn];
   stepSPL = [s1.delattn s2.delattn ];   
   Qstr = trimspace(s1.file_name);
   if Qstr(end)=='+', noiseSign = 1;
   else, noiseSign = -1;
   end
end
