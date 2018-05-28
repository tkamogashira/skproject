function deallot(Dbn);
% deallot - APOS deallot: deallocate DAMA buffer Dbn
%   Deallot(DBN) deallocates DAMA buffer with index DBN.
%   DBN may also be vector 

for dbn=Dbn(:).',
   s232('deallot', dbn);
end
