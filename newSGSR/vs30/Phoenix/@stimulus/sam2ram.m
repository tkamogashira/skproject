function [S, L] = sam2ram(S, ichunk, keyword);
% stimulus/sam2ram - upload samples of Stimulus object to RAM of D/A converter
%   ST = Sam2ram(ST,I) loads the samples of chunks with index I
%   to the current D/A device as determined by TDTsystem.
%   If I=0 or unspecified then all chunks in S are uploaded, 
%   that is, I = 1:length(ST.chunk).
%   Internal bookkeeping within S keeps track of the RAM buffers
%   used to store the samples. This enables stimulus/play to
%   assemble the hardware instructions for D/A conversion.
%
%   Sam2ram(ST,I, 'clear') clears and deallocates the buffers
%   previously allocated by Sam2ram. When I=0, all buffers
%   allocated for S are cleared.
%
%   [X L] = Sam2ram(ST, I, 'retrieve') gets the samples
%   of the chunks with index(es) I from their RAM buffers 
%   and concatenates them into a single row vector X. The
%   respective lengths of the individual chunks are in 
%   vector L. Thus length(X)=sum(L).
%
%   See also TDTsystem, stimulus/addchunk, stimulus/play.

if nargin<2, ichunk = 0; end % default: I=0 means all chunks
if nargin<3, keyword = 'upload'; end;

if nargout<1,
   error('Not enough output arguments. Syntax: ST = upload(ST,...).');
end

if isequal(0,ichunk), ichunk = 1:length(S.chunk); end % all chunks


switch lower(keyword),
case 'upload',
   S = localUpload(S, ichunk);
case 'clear',
   S = localClear(S, ichunk);
case 'retrieve',
   [S, L] = localRetrieve(S, ichunk);
otherwise error(['Invalid keyword ''' keyword '''.']);
end % switch/case
   
%--------------locals----------------------
function S = localUpload(S, Ichunk);
switch TDTsystem,
case 'sys2',
   for ichunk = Ichunk(:).',
      if ~isequal('sys2', S.chunk(ichunk).storage), % if not already stored in sys2 device
         if S.chunk(ichunk).Nsam==0, % empty buffers cannot be stored; convention ..
            S.chunk(ichunk).address = nan; % .. is that they have DBN=nan. See stimulus/play
         else,
            S.chunk(ichunk).address = ML2dama(S.chunk(ichunk).samples(:).'); % as row vector
         end
         S.chunk(ichunk).storage = 'sys2';
      end
   end
   S.globalInfo.storage = 'sys2';
case 'sys3',
   for ichunk = Ichunk(:).',
      if S.chunk(ichunk).Nsam==0, % empty buffers cannot be stored; convention ..
         S.chunk(ichunk).address = nan; % .. is that they have adress=nan. See stimulus/play
      else,
         S.chunk(ichunk).address = ML2dama(S.chunk(ichunk).samples(:).'); % as row vector
      end
      S.chunk(ichunk).storage = 'sys2';
   end
   S.globalInfo.storage = 'sys2';
otherwise,
   error(['Sample upload for TDTsystem = ''' TDTsystem ''' not implemented.']);
end

function S = localClear(S, Ichunk);
switch TDTsystem,
case 'sys2',
   for ichunk = Ichunk(:).',
      if isequal('sys2', S.chunk(ichunk).storage), % if not already stored in sys2 device
         if S.chunk(ichunk).Nsam>0, % empty buffers were never stored see localUpload
            deallot(S.chunk(ichunk).address);
         end
         S.chunk(ichunk).address = nan;
         S.chunk(ichunk).storage = 'none';
      end
   end
case 'sys3',
   error NYI;
otherwise,
   error(['Sample clearance for TDTsystem = ''' TDTsystem ''' not implemented.']);
end

function [Y, L] = localRetrieve(S, Ichunk);
switch TDTsystem,
case 'sys2',
   Y = []; L = [];
   for ichunk = Ichunk(:).',
      if ~isequal('sys2', S.chunk(ichunk).storage), % if not already stored in sys2 device
         error(['Chunk # ''' num2str(ichunk) '''is not stored in sys2 DAMA buffer.']);
      end
      DBN = S.chunk(ichunk).address;
      if DBN>0, Y = [Y dama2ML(DBN)]; end
      L = [L S.chunk(ichunk).Nsam];
   end
case 'sys3',
   error NYI;
otherwise,
   error(['Sample clearance for TDTsystem = ''' TDTsystem ''' not implemented.']);
end



