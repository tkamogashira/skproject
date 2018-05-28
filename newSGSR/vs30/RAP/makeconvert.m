function makeconvert(FN, sdir);
% makeconvert(FN, sdir) generates script that converts
% the data from datafile FN into RAP format.
% Example:
%
%   makeconvert('D0121','c:\temp\dries')
%
% Generates m-file c:\temp\dries\convertD0121.m. This script
% will convert FN to RAP format. Sdir will also show up in the
% farm2rap commands in the m-file, i.e., the rap files will be
% written to directory sdir. Sdir must exist.
%
% Makeconvert also adds sdir to the path (current session only).
%
% See also farm2rap.

FFN = [datadir filesep FN '.log'];
fid = fopen(FFN, 'rt')

CFN = [sdir '\convert' FN '.m']
fidw = fopen(CFN, 'wt')

while 1,
   ll = fgetl(fid);
   if ~ischar(ll), break; end;
   fL = max(findstr(ll,'<'));
   fR = min(findstr(ll,'>'));
   if ~isempty(fL) & ~isempty(fR),
      ll = ll(fL+1:fR-1);
      fR = min(findstr(ll,'>'));
      fprintf(CFN, '%s\n', ['farm2rap ' FN  '  ' ll ' ' sdir]);
   end
end
fclose all

path(path, sdir);
