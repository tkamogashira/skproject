function y=LookAtDataSession(varargin);

% LookAtDataSession - start session to analyze data

if inLeuven,
   dd = 'C:\usr\Marcel\data\BN';
else,
   dd = 'D:\SGSRwork\ExpData\Leuven';
end
setdirectories('external', 'IdfSpk', 'data directory', dd);
testsession;
cd(datadir);
