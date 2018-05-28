function y = SeqplayList(iwave, Nrep, iwaveR, NrepR);
% SeqplayList - specify play list for sequenced play
%   SeqplayPlaylist(iwave, nrep, iwaveR, NrepR) specifies a play list with:
%     iwav:     vector contaning indices>=1 indicating the waveforms
%               previously loaded by SeqplayUpload. A single
%               index may occur multiple times in the list.
%               In binaural mode, this vector serves as left channel.
%     nrep:     respective repetition counts.
%               In binaural mode, nrep is used for the left channel.
%     iwavR:    In binaural mode, this vector is taken for right channel.
%     nrepR:    In binaural mode, this is taken for right channel.
% 
%   In monaural mode, only two arguments (iwave,nrep) are expected.
%   The play mode (monaural vs binaural) is determined by SeqplayUpload: monaural
%   means that one of the arguments to SeqplayUpload was empty.
%
%   For a play list to be specified, the buffers must have been uploaded. The same
%   collection of buffers can be used with different play lists without having to
%   upload the waveforms again; a call to SeqplayList overrides any previous list 
%   specification.
% 
%   Type 'help Seqplay' to get an overview of sequenced playback.
% 
%   See also SeqplayInit, SeqplayUpload, SeqplayGo, SeqplayStatus.
        

% ===================== Initialisation ==================================================== %

SPinfo = SeqplayInfo; % checking of initialization and circuitID is implicit in this call

if ~isequal( 'uploaded', SPinfo.Status ) & ~isequal( 'listed', SPinfo.Status ),
   error('No sound samples uploaded. Call SeqplayUpload first.');
end

SwitchDelay = 1;

% ===================== Check arguments =================================================== %

switch nargin,
case 0,
   error('No playlist specified. Type "help SeqplayList" for help.');
case 1,
   if ~isequal( 'double', class(iwave) )
      error( 'args must be doubles' );
   else
      error('Repetitions must be specified.');
   end
case 2,
   if ~isequal( 'double', class(Nrep) )
      error( 'args must be doubles' );
   elseif isequal( 0, SPinfo.NBuffL )
      iwaveR = iwave; NrepR = Nrep;
      iwave = []; Nrep = []; %monaural play
   elseif isequal( 0, SPinfo.NBuffR )
      iwaveR = []; NrepR = []; %monaural play
   else
      error('Binaural play was initialized: specify playlist for both channels');
   end
case 3,
   if ~isequal( 'double', class(iwaveR) ),
      error( 'args must be doubles' );
   else,
      error('Repetitions must be specified.');
   end
case 4,
   if ~isequal( 'double', class(NrepR) ), 
      error( 'args must be doubles' );
   elseif ( isequal( 0, SPinfo.NBuffL ) | isequal( 0, SPinfo.NBuffR ) ) ...%monaural play: pass 2 arguments
         & ~( isempty( iwaveR ) )  % or let args 3&4 be []
      error('Monaural play was initialized. Too many arguments.');
   end
end      % nargin > 4: handled by matlab

if isempty(iwave) & isempty(iwaveR)
   error('Both sides are empty. SeqplayList aborted.');
end

if ~isequal(length(iwave), length(Nrep)) | ~isequal(length(iwaveR), length(NrepR)),
   error('iwave and Nrep args must have same size.')
end

if (~isempty(iwave) & ~isequal(1,size(iwave,1))) ...
      | (~isempty(iwaveR) & ~isequal(1,size(iwaveR,1))),
   error('iwave and Nrep args must be row vectors');
end


% ===================== Perform extra checks ============================================== %

if (sum(Nrep) > 1e6) | (sum(NrepR) > 1e6)
   error('Too many repetitions, max 1e+006 per side');
end

if any(iwave>SPinfo.NBuffL), error('L buffer index exceeds # uploaded buffers'); end
if any(iwaveR>SPinfo.NBuffR), error('R buffer index exceeds # uploaded buffers'); end

% ===================== Offsets and Switchlist for upload ================================= %

% Calculate lengths of songs
LengthL = sum(SPinfo.NsamL(iwave).*Nrep);    
LengthR = sum(SPinfo.NsamR(iwaveR).*NrepR);

% Number of zeros to be appended
NappendL = max(0,LengthR-LengthL);           
NappendR = max(0,LengthL-LengthR);

% Append zeros
[NsamL, iwave, Nrep] = ...
   localAppendZeros(NappendL, SPinfo.LeadingZeros, SPinfo.NsamL, iwave, Nrep, SPinfo.ZeroBufL);
[NsamR, iwaveR, NrepR] = ...
   localAppendZeros(NappendR, SPinfo.LeadingZeros, SPinfo.NsamR, iwaveR, NrepR, SPinfo.ZeroBufR);

% realize repetitions by repeating elements of iwave
Xiwave = localImplementRepeats(iwave,Nrep); % "X" means expanded
XiwaveR = localImplementRepeats(iwaveR,NrepR);

NplayL = sum(NsamL(Xiwave));
NplayR = sum(NsamR(XiwaveR));
if ~isequal(NplayL,NplayR),
   error('Bookkeeping error - unequal L/R sample counts .. contact Kevin')
end
% the D/A conversion should stop in the middle of playing the last, "fake" zero buffer
EndSample = NplayL-SPinfo.NmarginZeros+1; % sample at which playback ends; circuit will automatically halt

% Generate buffers
[SwitchListL, PlayOffsetsL] = localGenerateBuffers( SPinfo.OffsetL, NsamL, Xiwave, SwitchDelay);
[SwitchListR, PlayOffsetsR] = localGenerateBuffers( SPinfo.OffsetR, NsamR, XiwaveR, SwitchDelay);
                        
% ===================== Write to circuit ================================================== %

% make sure that the circuit is not playing
SeqplayHalt(1); % 1: skip circuitID check

% Write Offsets and SwitchLists
sys3write(PlayOffsetsL, 'OffsetsL', SPinfo.Dev, 0, 'I32');
sys3write([SwitchListL -ones(1,13)], 'SwitchListL', SPinfo.Dev, 0, 'I32'); % trailing impossible values to overwrite any obsolete switch times
sys3write(PlayOffsetsR, 'OffsetsR', SPinfo.Dev, 0, 'I32');
sys3write([SwitchListR  -ones(1,13)], 'SwitchListR', SPinfo.Dev, 0, 'I32'); % trailing impossible values to overwrite any obsolete switch times

% Write Endsample
sys3setpar(EndSample, 'EndSample', SPinfo.Dev);

% ===================== Adjust SPinfo ===================================================== %

newSPinfo.Status = 'listed';
newSPinfo.iwaveL = iwave;
newSPinfo.iwaveR = iwaveR;
newSPinfo.XiwaveL = Xiwave;
newSPinfo.XiwaveR = XiwaveR;
newSPinfo.NrepL = Nrep;
newSPinfo.NrepR = NrepR;
newSPinfo.NsamL = NsamL;
newSPinfo.NsamR = NsamR;

% store playlist info in persistent SPinfo for use in SeqplayStatus
y = SeqplayInit('setfield',newSPinfo);


% ===================== LOCAL FUNCTIONS =================================================== %

function [SwitchList, PlayOffsets] = localGenerateBuffers( BuffOffsets, BuffNsam, iwave, SwitchDelay )
% As sequenced play is started, a counter 'Tick' in the circuit starts counting up from zero.
% Actually played samples are positioned at Tick + Offsets stored in a buffer.
% A buffer "SwitchList" contains Ticks at which is switched to the next Offset.

    PlayOffsets = BuffOffsets( iwave );
    PlayNsam = BuffNsam(iwave);
   
    SwitchList = cumsum( PlayNsam );
	
    % Actually played samples are positioned at Tick + Offsets: we need to compensate for this
    % Also compensate for reaction time of 1 sample after Switch
	PlayOffsets = PlayOffsets - [0 SwitchList( 1:(end-1) )] - SwitchDelay;
    
    
function new_iwave = localImplementRepeats(iwave, Nrep)
% implement repeats and return new, expanded iwave including the reps
	new_iwave = [];
	for ii=1:length(iwave),
       tail = repmat(iwave(ii), 1, Nrep(ii)); 
       new_iwave = [new_iwave tail];
	end

    
function [Nsam, iwave, Nrep] = localAppendZeros(Nappend, LeadingZeros, Nsam, iwave, Nrep, ZeroBuf);
% append zero-filled buffers to play list
    
    NsamRem = rem(Nappend, LeadingZeros); % # sam for last "remainder" buffer
	NZeroBlocks = floor( Nappend / LeadingZeros );   % # blocks of zeros as needed
	
    Nsam(ZeroBuf.iBufRemZero) = NsamRem; % replace NaN (see upload)
	
    % prepend small zero buffer and append large zero buffer
	iwave = [ZeroBuf.iBufSmallZero  iwave  ZeroBuf.iBufLargeZero];
	Nrep = [1                       Nrep   NZeroBlocks];
    % append remainder zero buffer if needed
    if NsamRem>0, 
       iwave = [iwave  ZeroBuf.iBufRemZero];
       Nrep = [Nrep 1];
    end
    % append small zero buffer
	iwave = [ iwave  ZeroBuf.iBufSmallZero ];
	Nrep =  [ Nrep   1];