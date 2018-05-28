function dp = disp(ST, Nindent);
% stimulus/disp - disp for stimulus objects
%   disp(ST) displays stimulus object ST.
%
%   D = DISP(ST) returns the same info as char string.
%
%   DISP(ST,N) uses N indent spaces instead of default 5.
%
%   See also DISP and documentation on Stimulus objects.

if nargin<2 Nindent = 5; end;

if isempty(ST),
   d = 'empty stimulus object';
elseif numel(ST)>1,
   d = '';
   for ii=1:numel(ST),
      dii = disp(ST(ii),0); % no indent
      num = sprintf('%3d: ', ii);
      d = strvcat(d, [num dii]);
   end
elseif isvoid(ST),
   d = 'void stimulus object';
else, % single elem
   d = [sprintf('%6s', ST.name) ' stimulus'];
   Nchunk =  length(ST.chunk);
   Nwav = length(ST.waveform);
   Nshot =  length(ST.DAshot);
   Nstr = [num2str(Nchunk) ' chunks, '   num2str(Nwav) ' waveforms, '   num2str(Nshot) ' DAshots'];
   d = [d, ' ' bracket(Nstr,1,'()')];
end

% provide indent space
d = [repmat(' ', size(d,1), Nindent) d];

if nargout<1, disp(d); % display if no argout is requested
else, dp = d; % return argout; do not display
end;






