function C = CodeSpikeTimes(SPT, Unsigned);
% CodeSpikeTimes - codes spike time array so as to save space
%
% See also DecodeSpikeTimes

if nargin<2, Unsigned=1; end;
if (~isequal(size(SPT,1),1)&~isempty(SPT)) | ndims(SPT)>2,
   error('SPT arg must be row vector');
end
if ~isequal(SPT,round(SPT)),
   error('spike times must be integer values');
end

N = length(SPT);
isi = diff([0 SPT]);

if isempty(SPT),
   isi = SPT; % preserve exact dimensions, i.e. 0x1 double or []
   shift = 0;
   isi16 = uint16([]);
   UpperBound = nan;
elseif Unsigned,
   LowBound = 0;
   UpperBound = 2^16-2;
   shift = 0;
else,
   LowBound = -2^15+1;
   UpperBound = 2^15-2;
   shift = round(median(isi));
end
Flag = UpperBound+1;

if ~isempty(SPT),
   Not16 = find((isi<LowBound) | (isi>UpperBound)); 
   N16 = N - length(Not16);
   if 2*N16>N, % worth coding
      if Unsigned, isi16 = uint16(isi);
      else, isi16 = int16(isi);
      end
      isi16(Not16) = Flag;
      isi = isi(Not16);
   else,
      isi16 = uint16([]);
   end
end

C = CollectInStruct(isi, shift, Flag, isi16);

