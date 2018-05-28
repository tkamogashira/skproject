function bv = EREVbufVar(cha);
% EREVbufVar - returns bufVar of either EREVnoiseL or EREVnoiseR
global EREVnoiseL EREVnoiseR
if nargin<1, % try both
   bv = [];
   try
      if ~isempty(EREVnoiseL),
         bv = EREVnoiseL.BufVar;
      elseif ~isempty(EREVnoiseR),
         bv = EREVnoiseR.BufVar;
      end
   end %try
else
   eval(['bv = EREVnoise' cha '.BufVar;']);
end
   