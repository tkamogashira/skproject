function str = ShowStimParam(ds, inNotePad);
% ShowStimParam - show stimulus parameter 
%   ShowStimParam(DS) displays stimulus parameters of dataset DS on screen.
%   S = ShowStimParam(DS) will return it in char string array.
%   ShowStimParam(DS,1) will display the info in a separate NotePad window. 
%
%   See also DSinfoString

if nargin<1, ds = []; end;
if nargin<2, inNotePad = 0; end;
if isempty(ds), ds = curDS; end
Q = char(disp(ds));
% split 1st, long, line
line1 = words2cell(Q(1,:),',');
isplit = strfind(Q(1,:), line1{3});
line1_2 = strvcat(Q(1,1:isplit-1), ['    ' Q(1,isplit:end)]);
Q = strvcat(line1_2, Q(2:end,:));
ds = emptydataset(ds); 
switch lower(ds.FileFormat),
case 'idf/spk', P = FarmDisp(ds);
otherwise, P = SGSRdisp(ds);
end % switch/case
infoStr = strvcat(Q,' ',P);
infoStr = deblank(infoStr);
if inNotePad,
   ViewTextInNotePad([tempdir '\StimParamInfo'], infoStr, pi);
elseif nargout<1, disp(infoStr); 
else, str = infoStr;
end


