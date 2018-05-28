function Fsam = InitBoardLeds(flag, Dev, circuitName);
% InitBoardLEDs - load circuit to control LedBoard fixation LED and 4 choice LEDs.
%    InitBoardLEDs initializes the circuit for LED control. Call this function one
%    before using fixledcontrol, boardLED FixLEDdelay.
%    If the circuit is already loaded and running; no action is taken.
%
%    InitBoardLEDs('force') always (re)loads the circuit.
%
%    InitBoardLEDs('fsam') returns the sample freq in Hz of the circuit.

persistent FSAM

if nargin<1, flag = 'init'; end
if nargin<2, Dev = 'RP2_2'; end
if nargin<3, circuitName = 'Eyetrack'; end

switch lower(flag),
case 'fsam',
case 'init',
   try, sys3getpar([circuitName '.ID'], Dev); % this partag must be unique to the circuit
   catch, % getpar failed - circuit not running OK
      FSAM = localLoad(Dev, circuitName);
   end
case 'force',
   FSAM = localLoad(Dev, circuitName);
otherwise error(['Invalid flag ''' flag '''.']);
end

try, sys3getpar([circuitName '.ID'], Dev); % this partag must be unique to the  circuit
catch, % getpar failed - circuit not running OK
   error(['Unable to load circuit ''' circuitName ''' or circuit lacks an identifier tag.']);
end

% check if dvice is running - if not make it run
Status = sys3status(Dev); % bit #2 is Circuit Running status
if ~bitand(Status, uint32(2^2)), sys3run(Dev); end

Fsam = FSAM;


% ==================
function FSAM = localLoad(Dev, circuitName);
FSAM = sys3loadCOF(circuitName, Dev, 6);     
