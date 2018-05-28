function cc = StructComp(sp1, sp2, ignore);
% SGSRPARCOMP - compare stimulus parameters of two SGSR sequences
%   SGSRPAR(FN,I,J) returns a struct containing the stimpar fields in which
%   seqs I and J differ. The different values are displayed as cells.
%   The string "same" is returned if the parameters of the sequences are 
%   the same.
%
%   See also SGSRPAR, getSGSRdata

if nargin<3, ignore={}; end;
ignore = cellstr(ignore);

if isequal(sp1,sp2), cc = [];
else,
   cc= struct('dummydummy',[]);
   fns = fieldnames(sp1);
   for ii=1:length(fns),
      fn = fns{ii};
      v1 = getfield(sp1,fn);
      v2 = getfield(sp2,fn);
      if ~isequal(v1,v2) & isempty(strfindcell(ignore,fn)),
         cc = setfield(cc,fn,{v1, v2});
      end
   end
   cc = rmfield(cc,'dummydummy');
end

