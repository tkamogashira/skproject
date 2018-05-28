function y = SeqplayUpload(LBuff, RBuff);
% SeqplayUpload - Upload samples for sequenced play over TDT device
%   SeqplayUpload(Lbuff{SL1,SL2,...}, Rbuff{SR1,SR2,...}) uploads waveforms SL1, SL2, .. 
%   to the left channel, and waveforms SR1, SR2, .. to the right channel, in
%   preparation for sequenced playback. Individual waveforms must be column vectors
%   containing at least 2 samples. Different waveforms may have different lengths.
%   The samples are uploaded to the device.
%
%   For monaural playback, upload an empty buffer cell {} to the non-active channel.
%
%   SeqplayUpload returns a struct containing details of the sequenced play setup.
%
%   Type 'help Seqplay' to get an overview of sequenced playback.
%
%   See also SeqplayInit, SeqplayList, SeqplayGO, SeqplayHalt, SeqplayStatus.


% ===================== Initialisation ==================================================== %

% Leading zeros in sound buffers.
% This number will be stored in SPinfo, so this is the place to change it!

LeadingZeros = 1000; % Length of appende zero buffer
NmarginZeros = 5; % Zero samples prepended and appended to samples for safety

LeftEmpty = 0; RightEmpty = 0; % false

SPinfo = SeqplayInfo; % checking of initialization and circuitID is implicit in this call


% ===================== Check number of arguments ========================================= %

if nargin == 0,
   error('Check syntax: no arguments found. Type "help SeqplayUpload" for help.');   
elseif nargin == 1,
   error('Both channels should be uploaded together. To leave one side empty, upload empty cell array {}.');
end  % nargin > 2 is handled by Matlab


% ===================== Check argument contents =========================================== %

if ~isequal( 'cell', class(LBuff) ) | ~isequal( 'cell', class(LBuff) ),
   error('Input arguments should be cell arrays.');
end

if isequal( 0, length(LBuff) ),
%   warning('Left side is left empty, monaural play activated.');
   LeftEmpty = 1;
elseif ~isequal( 1, size(LBuff,1) ),
   error('RBuff: Input arguments should be horizontal cell arrays containing column vectors. Type "help SeqplayUpload" for help.');
end

if isequal( 0, length(RBuff) ),
%   warning('Right side is left empty, monaural play activated.');
   RightEmpty = 1;
elseif ~isequal( 1, size(RBuff,1) ),
   error('RBuff: Input arguments should be horizontal cell arrays containing column vectors. Type "help SeqplayUpload" for help.');
end

if LeftEmpty & RightEmpty,
   error('Both sides are empty. Upload aborted.');
end

for cLeft = 1:size( LBuff, 2 ),
   if ~isequal( 'double', class(LBuff{cLeft}) ) | ~isequal( 1, size(LBuff{cLeft}, 2) ),
      error('LBuff: Sound buffers should be double valued column vectors.');
   end
end

for cRight = 1:size( RBuff, 2 ),
   if ~isequal( 'double', class(RBuff{cRight}) ) | ~isequal( 1, size(RBuff{cRight}, 2) ),
      error('RBuff: Sound buffers should be double valued column vectors.');
   end
end


% ===================== Check for buffer overflow ========================================= %

LSize=0;RSize=0;
for cLeft = 1:size(LBuff,2),
    LSize = LSize + size(LBuff{cLeft},1);
end
for cRight = 1:size(RBuff,2),
    RSize = RSize + size(RBuff{cRight},1);
end

if LSize > 1e6 | RSize > 1e6,
   error('Too many samples. Max = 1e+006 per side.');
end


% ===================== Process waveforms ================================================= %

% Process waveforms
[GrandWaveL, OffsetL, NsamL, ZeroBufL] = localProcessCellBuff( LBuff, NmarginZeros, LeadingZeros ); 
[GrandWaveR, OffsetR, NsamR, ZeroBufR] = localProcessCellBuff( RBuff, NmarginZeros, LeadingZeros ); 

if ( length(GrandWaveR) > 1e6 )  |  ( length(GrandWaveL) > 1e6 ),
   error('Too many samples; max total datapoints for each side: 1e+006');
end

% Upload them samples
sys3write(GrandWaveL, 'SamplesL', SPinfo.Dev, 0, 'F32'); 
sys3write(GrandWaveR, 'SamplesR', SPinfo.Dev, 0, 'F32'); 


% ===================== Store new info in persistent SPinfo =============================== %

% make sure to discard all previous playlist info
iwaveL = []; NrepL = []; XiwaveL = []; 
iwaveR = []; NrepR = []; XiwaveR = []; 
sepa = SPinfo.sepa0; 

newSPinfo = collectInStruct(NmarginZeros, LeadingZeros);

newSPinfo.sepa1      = sepa;

newSPinfo.NBuffL     = length(LBuff);
newSPinfo.OffsetL    = OffsetL;
newSPinfo.NsamL      = NsamL;
newSPinfo.totalNsamL = sum(NsamL([1:end-3 end-1])); % buffers @ end-2 and end are fake

newSPinfo.sepa2      = sepa;

newSPinfo.NBuffR     = length(RBuff);
newSPinfo.OffsetR    = OffsetR;
newSPinfo.NsamR      = NsamR;
newSPinfo.totalNsamR = sum(NsamR([1:end-3 end-1])); % buffers @ end-2 and end are fake

newSPinfo.sepa3      = sepa;

newSPinfo.iwaveL     = iwaveL;
newSPinfo.NrepL      = NrepL;
newSPinfo.XiwaveL    = XiwaveL;
newSPinfo.sepa4      = sepa;

newSPinfo.iwaveR     = iwaveR;
newSPinfo.NrepR      = NrepR;
newSPinfo.XiwaveR    = XiwaveR;
newSPinfo.sepa5      = sepa;

newSPinfo.ZeroBufL = ZeroBufL;
newSPinfo.ZeroBufR = ZeroBufR;

newSPinfo.Status = 'uploaded';

SPinfo = SeqplayInit('setfield', newSPinfo);
y = SPinfo;


% ===================== LOCAL FUNCTIONS =================================================== %

function [GrandWave, Offset, Nsam, ZeroBuf] = localProcessCellBuff( CellBuff, NmarginZeros, LeadingZeros )
% Concatenate waveforms while storing offsets

    
    Offset = LeadingZeros; % offsets start after safety buffer containing zeros. The circuit wil start and halt here.
    Nsam = [];
    GrandWave = zeros(LeadingZeros,1);
    
    % fill Grandwave and Offset
    Nbuf = length(CellBuff); % # user-defined buffers
    for iwave = 1:Nbuf,
       samples = CellBuff{iwave};
       if length(samples) < 2,
          error('buffers should be longer than one sample');
       end
       
       GrandWave = [GrandWave; samples];
       Offset = [Offset, size(GrandWave,1)];
    end
    Nsam = diff(Offset);
    Offset = Offset(1:(end-1)); % remove end of last buffer
    

    % add three zero-filled buffers for appended silence and margins
    Offset = [Offset 0 0 0]; % the zeros point to the first LeadingZeros zeros in the grand buffer
    Nsam = [Nsam NmarginZeros LeadingZeros nan]; % the last buffer is the remainder - only known at seqlist time
    iBufSmallZero = Nbuf+1;
    iBufLargeZero = Nbuf+2;
    iBufRemZero = Nbuf+3;
    ZeroBuf = collectInStruct(iBufSmallZero, iBufLargeZero, iBufRemZero);
    
    
    
    
    
    