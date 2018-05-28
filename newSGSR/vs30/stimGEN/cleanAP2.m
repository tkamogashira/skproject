function OK= cleanAP2(checkET1);

persistent testFailed
if nargin<1, checkET1=0; end;

if isequal(checkET1,'allwaysfix'),
   testFailed = 1
   return;
end

OK = 0;
% function cleanAP2; - clears AP2 memory and initializes special buffers
try
   s232('trash'); % deallocates all DAMA buffers
   s232('dropall'); % empties AP2 stack
   if isempty(testFailed),
      testFailed = ~damaTest;
      if testFailed,
         eh = errordlg(strvcat('---AP2 memory prblems---',  ...
            'PC MUST BE RE-BOOTED !!', ...
            '(or TDT hardware cannot be used)'), ...
            'Fatal hardware problem.', 'Modal');
         waitfor(eh);
         % disable hardware use
         global SGSR
         SGSR.TDTpresent = 0;
         % tell user
         addToLog('AP2 MEMORY PROBLEMS - REBOOT PC');
         return;
      end
   end
   if testFailed, % fill dubious memory with garbage
      N=5e5; s232('pushf',1:N,N); 
   end
   initspecialbufs; % initializes generic silence and sycn buffers
   OK = 1;
catch
   return
end
% calibrate clocks of et1 and pd1 if this hasn't been done recently
if checkET1, 
   if isequal(-1,checkET1), clear testET1andPD1; end;
   OK = testET1andPD1; 
end;


