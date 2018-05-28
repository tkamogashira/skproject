function OUIdepvarInfo(depVar, precision, OUIitem, maxN);
% OUIdepvarInfo - display info on dependent variable on OUI
%   OUIdepvarInfo(depVar, precision, OUIitem, maxN)
%   displays the number of conditions to OUI item name 'Ncondition'
%   and displays the values of the dependent variable as a tooltip
%   to OUIitem. depVar is a parameter object containing the 
%   respective values of th dependent variable.
%
%   Precision determines the precision of the numerical
%   format. i.e., of Precision=1, all values are rounded to the
%   nearest integer value. If there are more than maxN values, 
%   ellipses are used to limit the size of the tooltip.
%   Default value for maxN is 20.

if nargin<4, maxN=20; end;

if isempty(paramOUI), return; end % don't bother if no OUI is active

% rounded values to be displayed
dval = precision*round(1/precision*depVar.value);
Ncond = size(dval, 1);
OUIhandle('Ncondition', ['# cond: ' num2sstr(Ncond)]);


if Ncond> maxN, % thow out middle values
   halfMax = floor(maxN/2);
   width = size(dval,2);
   dval = [dval(1:halfMax,:); zeros(1,width); dval(end-halfMax+1:end,:)];
end
Ndisp = size(dval,1); 
valStr = num2str(dval);
% add units
valStr = [valStr repmat([' ' depVar.unit], Ndisp,1)];

if Ncond> maxN, % insert ellipses
   width = size(valStr,2);
   ellipses = [' ' repmat('.', 1, width-2) ' '];
   valStr(halfMax+1,:) = ellipses;
end
% for tooltips, we need need single line with newlines, not char matrix or cellstr
valStr = errorStr(valStr);
OUIhandle(OUIitem, nan, 'tooltip', valStr);









