function sf=experimenter;
% experimenter - returns name of experimenter as specified during initialization of session
%    An empty string is returned if no SESSION was properly defined

global SESSION
try
   sf = [SESSION.Experimenter];
catch
   sf = '';
end
