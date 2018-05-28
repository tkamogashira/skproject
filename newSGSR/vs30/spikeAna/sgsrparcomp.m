function cc = sgsrParComp(DataFile,iSeq1, iSeq2);
% SGSRPARCOMP - compare stimulus parameters of two SGSR sequences
%   SGSRPAR(FN,I,J) returns a struct containing the stimpar fields in which
%   seqs I and J differ. The different values are displayed as cells.
%   The string "same" is returned if the parameters of the sequences are 
%   the same.
%
%   See also SGSRPAR, getSGSRdata

if nargin<3, iSeq2=iSeq1+1; end; % compare to next one

sp1 = rmfield(sgsrPar(DataFile,iSeq1), 'i_____Seq');
sp2 = rmfield(sgsrPar(DataFile,iSeq2), 'i_____Seq');
if isequal(sp1,sp2), cc = 'same';
else,
   cc= struct('dummydummy',[]);
   fns = fieldnames(sp1);
   for ii=1:length(fns),
      fn = fns{ii};
      v1 = getfield(sp1,fn);
      v2 = getfield(sp2,fn);
      if ~isequal(v1,v2),
         cc = setfield(cc,fn,{v1, v2});
      end
   end
   cc = rmfield(cc,'dummydummy');
end

