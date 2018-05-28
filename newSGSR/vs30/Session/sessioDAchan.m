function c = SessioDaChan;
% SESSIODACHAN - returns active DA channels as specified at sessio init
try
   global SESSION
   c = SESSION.DAchannel;
catch
   error(['No sessio' 'n initialized.']);
end
