function ReportProgress(PorR, iSeq);
% reports progress of play/record activities
persistent iPlay iRec VVstr TimeToGo VVlabel N

if isequal('init',PorR), % initialize persistent values
   global PRPinstr
   if isempty(PRPinstr.PLOT),
      VVlabel = {'' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' '' };
   else,
      VVlabel = PRPinstr.PLOT.VVlabel;
   end
   iPlay = [];
   iRec = [];
   VVstr = [];
   % 2nd arg is used to specify durations of subseqs
   sDur = 1e-3 * iSeq; % dur of each subseq in s
   N = length(sDur);
   tDur = sum(sDur);
   cDur = cumsum(sDur);
   TimeToGo = round(tDur - [0, cDur(1:(N-1))]);
   return;
end;
if nargin<2, iSeq=N; end;
Vstr = [' (' VVlabel{iSeq} ')'];
pstr = 'playing subseq ';
rstr = 'recording subseq ';
if nargin>1, ttgStr = ['time left ~ ' num2str(TimeToGo(iSeq)) ' s'];
else,
   ttgStr = '';
end
if isequal(PorR,'play'),
   iPlay = iSeq;
   VVstr = Vstr;
elseif isequal(PorR,'pstop'),
   iPlay = iSeq;
   VVstr = Vstr;
   pstr = ['stopped playing at subseq '];
elseif isequal(PorR,'record'),
   iRec = iSeq;
elseif isequal(PorR,'rstop'),
   iRec = iSeq;
   rstr = 'stopped recording at subseq ';
elseif isequal(PorR,'pfinish'),
   pstr = 'finished playing at subseq ';
elseif isequal(PorR,'rfinish'),
   rstr = 'finished playing at ';
end
if isempty(iRec), rstr = ''; end;
repStr = strvcat(...
   [pstr num2str(iPlay) VVstr],...
   [rstr num2str(iRec)],...
   ttgStr);
UIinfo(repStr,[],[],0); % 0-> no drawnow
