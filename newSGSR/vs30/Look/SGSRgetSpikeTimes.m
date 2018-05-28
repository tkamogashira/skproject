function [spt, pp, isub] = SGSRgetSpikeTimes(FN, iSeq, ForceType);
% get pooled spike times of iSeq 
%  SYNTAX: [spt, pp, isub] = SGSRgetSpikeTimes(FN, iSeq);
if nargin<3, ForceType=''; end;

spt = [];
for iseq=iSeq,
   if ~isreal(iseq), % imag part is isub
      isub = imag(iseq);
   else,
      isub = 1;
   end
   dd = getSGSRdata(FN, real(iseq));
   if ~isempty(ForceType),
      if ~isequal(upper(ForceType),upper(dd.Header.StimName)),
         error(['Not a '  ForceType ' sequence']);
      end
   end
   spt = [spt getSpikesOfRep(isub,1,dd.SpikeTimes.spikes)]; % in ms!
   pp = sgsrpar(FN,real(iseq));
end
% fix bug in data storage A0123
try
   if isequal(999,pp.Tilt),
      Advice554 = [0     4    13    18    17    15];
      Advice556 = [0     1     4     9     8     6];
      if isequal(iSeq,555),     pp.Tilt = Advice554
      elseif isequal(iSeq,557), pp.Tilt = Advice556
      else, warning('Tilt = 999?!');
      end
   end
end %try
