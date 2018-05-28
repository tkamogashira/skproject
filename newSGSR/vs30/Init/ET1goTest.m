function [repOK, zerosOK] = ET1goTest(Dev, Ngo);

% tests ET1go effects

if nargin<1, Dev = 1; end;

repOK = 0; zerosOK = 0;
try
   % 1. elementary test of ET1: clear, give a number of go's
   %   and check if they are properly processed.
   SS1switching('N',1,1);
   pause(0.2);
   N = 103;
   s232('ET1clear',Dev);
   for ii=1:N, s232('ET1go',Dev); end;
   pause(0.1); 
   s232('ET1stop',1);
   % now check if all zeros are returned
   [RR repOK]= ET1getEvents(Dev, 1);
   zerosOK = isequal(RR,zeros(1,N));
catch
   disp(['error - ' lasterr]);
   dbstack;
   mess = strvcat('ET1 problems', 'Is the ET1 present and accessible?', 'MatLab mess:',lasterr);
   eh = errordlg(mess);
   if ishandle(eh), uiwait(eh); end;
   uimess('ET1 problems');
   success = 0;
end


