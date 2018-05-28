function hs = hcatstruct(s1,s2);
% HCATSTRUCT - field-wise horzcat of two struct variables
%   syntax: hs = hcatstruct(s1,s2);
%
%   See also VCATSTRUCT.

% special, trivial, cases
if isempty(s1),
   hs = s2; return;
elseif isempty(s2),
   hs = s1; return;
end

Fns = fieldnames(s1);
hs = s1;
for ii=1:length(Fns),
   fn = Fns{ii};
   eval(['hs.' fn ' = [hs.' fn  ', s2.' fn '];' ]);
end
