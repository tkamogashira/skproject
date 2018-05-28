function EV = checkZwuis(Kfreq);
% check zwuis candidate

Kfreq = Kfreq(:); % row vector
N = length(Kfreq);
QM = [];

% 1st order
for i=1:N,
   QM = [QM, localInteractionCols(N,i)];
end
% 2nd order
for i1=1:N,
   for i2=i1+1:N,
      QM = [QM, localInteractionCols(N,i1,i2)];
   end
end
% 3rd order
for i1=1:N,
   for i2=i1+1:N,
      for i3=i2+1:N,
         QM = [QM, localInteractionCols(N,i1,i2,i3)];
      end
   end
end
% 4th order
for i1=1:N,
   for i2=i1+1:N,
      for i3=i2+1:N,
         for i4=i3+1:N,
            QM = [QM, localInteractionCols(N,i1,i2,i3,i4)];
         end
      end
   end
end
dsiz(QM)
dsiz(Kfreq)
EV = QM'*Kfreq;


%----------------
function as = localAllSigns(N);
persistent AS % cache
if ~isempty(AS),
   if N<=length(AS),
      as = AS{N};
   end
else, AS{1} = []; % initialize
end
if N==1, as = [];
else,
   N = N-1;
   asm = localAllSigns(N);
   as = [[ones(1,2^N); asm], [-ones(1,2^N); asm]];
end
AS{N} = as;

function cc=localInteractionCols(N,varargin);
Ncomp = nargin-1;
ff = localAllSigns(Ncomp);
cc = zeros(N,size(ff,2));
for irow=1:size(ff,1),
   cc(varargin{irow},:) = ff(irow,:);
end



