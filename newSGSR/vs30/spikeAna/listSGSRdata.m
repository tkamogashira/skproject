function y=listSGSRdata(FN, iSeq, feat, noDisp);
% listSGSRdata - list features of SGSRdata 

if nargin<2, iSeq=0; end;
if nargin<3, feat = 'StimName'; end
if nargin<4, noDisp=0; end;

Nseq = getSGSRdata(FN,'nseq');
if isequal(iSeq,0), iSeq = 1:Nseq;
elseif isinf(iSeq), iSeq = Nseq;
end

y = [];
for iseq=iSeq(:)',
   DD = getSGSRdata(FN,iseq);
   eval(['val = DD.Header.' feat ';']);
   if isnumeric(val), 
      str = num2str(val);
      y(iseq) = val;
      dispStr = [num2str(iseq) ':   ' str];
   elseif ischar(val),
      str = val;
      if isempty(y), y = repmat(' ',max(iSeq),1); end;
      y = strvcat(y,str);
      y(iseq,1:length(str)) = str;
      y(end,:) = '';
      dispStr = [num2str(iseq) ':   ' str];
   elseif isstruct(val),
      fns = fieldnames(val);
      str = strvcat(fns{:});
      dispStr = strvcat(['--' num2str(iseq)], str);
      if isempty(y), clear y; end;
      y(iseq) = val;
   end
   if ~noDisp, disp(dispStr); end
end
