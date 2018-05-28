function [icell, CF] = CFlist(DF);
% CFlist - list of CFs of an experiment
%   [icell, CF] = CFlist(DF)

lut = log2lut(DF);
ithr=strfindcell({lut.IDstr},'THR');
for ii=1:length(ithr),
   qq = dataset(DF, lut(ithr(ii)).IDstr);
   icell(ii) = qq.icell;
   tc=qq.OtherData.thrCurve; 
   [dum imax]=min(tc.threshold); 
   CF(ii) = tc.freq(imax); 
end

