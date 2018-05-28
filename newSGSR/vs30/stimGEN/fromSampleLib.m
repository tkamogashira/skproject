function x = FromSampleLib(index);

% FromSampleLib - get a variable from global SampleLib struct

global SampleLib;

if isempty(SampleLib),
   error('empty sampleLib');
end

validIndex = isnumeric(index) ...
   & isreal(index) ...
   & isequal([1 1],size(index)) ...
   & (index>0)  ...
   & rem(index,1)==0;
if ~validIndex,
   error('invalid SampleLib index value');
end

if (length(SampleLib.cell)<index) | SampleLib.free(index),
   error('invalid sampleLib index');
end

x  = SampleLib.cell{index};






