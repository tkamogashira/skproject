function SeqPlayOrder(Order);

% SeqPlayOrder - specify chunk order for sequenced play on RP2
%   SeqPlayOrder(Order) specifies the order in which the
%   waveform chunks are to be played. The elements of the
%   vector Order indicate the respective chunk numbers,
%   counted from 1. Order may have any length upto 5000.
%
%   See also SeqPlayPrep, SeqPlayLoad, SeqPlayGo, SeqPlayStop.

ENDofList = -1;

offset = 0; 
Order = [1 2 Order+2];                      %%exclude first two buffers containing the 5 zeros

global SeqPlay_L;

for i=1:length(SeqPlay_L),
    nsam = SeqPlay_L(i);
    offset = [offset offset(end)+nsam];     %%calculate offsets
end

nsam = SeqPlay_L(Order);
totNsam = sum(nsam);
ncumsam = cumsum(nsam);                     %%total sample count after playing i-th token
jumpLoc = cumsum(nsam);   

%%make a global for JumpLoc
global SeqPlay_jumpLoc;
SeqPlay_jumpLoc = jumpLoc;

jumpLoc(1:2) = ENDofList;                   %%-1 = stop code

offset(end) = []; 
offsetCorrection = [0 ncumsam(1:end-1)];    %counter setting at begin of playing the i-th token
offset = offset(Order) - offsetCorrection;  %now playCounter + offset jumps at correct waveform
offset = [offset -jumpLoc(end)];

%%write offsets to RP2 buffer
sys3write(offset, 'SampleOffset', 'RP2_1', 0, 'I32');

%%reset counters
SeqPlayStop;    

%%write JumpLocations to RP2 buffer
sys3write([jumpLoc  ENDofList ENDofList], 'jumpLoc', 'RP2_1', 0, 'I32');  

