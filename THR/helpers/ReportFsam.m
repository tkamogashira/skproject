function Fstr = ReportFsam(figh, Fsam);
% ReportFsam - report sample rate FsamDisp panel 
%     ReportFsam(figh, Fsam) reports the sample frequency Fsam (in
%     kHz) to the FsamDisp messenger of the stimulus GUI having handle figh.
%
%     ReportFsam(figh, nan) resets the string of the FsamDisp messenger 
%     to its TestLine value (see Messenger).
%
%   See StimGUI, PlayTime, Messenger.

% compute and format
if isnan(Fsam),
    Fstr = 0; % results in TestLine, see Messenger/report
else,
    Fstr = ['Fsam = ' sprintf('%0.1f kHz', Fsam)];
end

% report
M = find(messenger(), figh, 'FsamDisp');
report(M,Fstr);



