function SaveBanana(d,md, mconf);
% SaveBanana(XL) - save last set of figures
global BN_ID
if isempty(BN_ID),
   error('no current BN ID'),
end
BN_ID
for ii=2:5,
   if ishandle(ii),
      FN = [datadir '\' BN_ID '_f' num2str(ii) '.fig'];
      saveas(ii, FN);
   end
end
