function OK = spkPlot(FN, iSeq);
% SGSRplot - quick & dirty plotting function for selection of SGSR-style data

OK = 0;
dd = getSGSRdata(FN, iSeq);
st = dd.Header.StimName,
switch st
case 'thr',
   thrplot(FN, iSeq);
   OK = 1;
case 'erev',
   warning([num2str(iSeq) ' is erev sequence; use fasterevana to pool data' ]);
otherwise
   warning(['Plot for ' upper(st) ' data not yet implemented']);
end


