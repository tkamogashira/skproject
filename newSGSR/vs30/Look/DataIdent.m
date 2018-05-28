function [FN, iSeq] = DataIdent(FN, iSeq, N);
% DataIdent - complete incomplete Filename/iseq info
%   Helper function for standard data analysis  functions like RAS

% N is nargin of the calling function

if N==0,
   FN = 'current datafile';
   iSeq = 'current dataset';
elseif N==1,
   if isnumeric(FN),
      % current datafile
      iSeq = FN;
      FN = 'current datafile';
   elseif ~isa(FN,'dataset'),
      error('Invalid FN input arg.');
   end
end

if isequal(FN, 'current datafile')
   try,
      FN = datafile;
      if isempty(FN), error('q'); end;
   catch, error('No default datafile defined.');
   end
end

if isequal(iSeq, 'current dataset')
   try,
      iSeq = IDrequest('current');
   catch, error('No current dataset defined.');
   end
end
