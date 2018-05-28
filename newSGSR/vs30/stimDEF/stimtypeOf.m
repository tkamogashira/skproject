function [stimtype, stimname] = stimtypeOf(X);
% stimtypeOf - stimtype (number) & stimname (string) of idfSeq, SD or SMS stimulus definition
%   usage: [stimtype, stimname] = stimtypeOf(X)

if isfield(X, 'stimcntrl'),
   stimtype = X.stimcntrl.stimtype;
   stimname = IDFstimName(stimtype);
elseif isfield(X.GlobalInfo, 'cmenu'), % old style stuff,
   stimtype = X.GlobalInfo.cmenu.stimcntrl.stimtype;
   stimname = IDFstimName(stimtype);
else,
   stimtype = NaN;
   stimname = X.GlobalInfo.stimName;
end

   

