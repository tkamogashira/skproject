function [N, V] = getnettime
%GETNETTIME get time and date over network
%   [N, V] = GETNETTIME gets exact date and time over network and returns this as a datenumber N, and as
%   datevector V.

%B. Van de Sande 14-08-2003

import java.io.* java.net.*

%Time Services by IRITI (Italy) ...
sURL = 'http://toi.iriti.cnr.it/uk/rightime.shtml';

%Retrieving HTML-page ...
URLobj = URL(sURL);
BufObj = BufferedReader(InputStreamReader(URLobj.openStream));

Line = char(BufObj.readLine); Txt = Line;
while ~isnumeric(Line), 
    Line = BufObj.readLine; 
    Txt = strvcat(Txt, char(Line));
end

BufObj.close;

clear('URLobj', 'BufObj');

%Parsing of HTML-page to extract date and time ...
idx = max(strfindcell(Txt, 'CEST <BR>'));
M = sscanf(Txt(idx, :), '%d:%d:%d CEST <BR> %s %d %s %d');

Hours   = M(1);
Minutes = M(2);
Seconds = M(3);

idx = find(M == ',');
DayName = char(M(4:idx-1))';
DayNr   = M(end);
Month   = char(M(idx+2:end-1)');
MonthNr = getmonthnr(Month);
Year    = M(idx+1);

V = [Year MonthNr DayNr Hours Minutes Seconds];
N = datenum(V);

%--------------------------------------------------------locals----------------------------------------------------
function Nr = getmonthnr(Str)

Months = {'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'};
Nr = find(ismember(Months, lower(Str(1:3))));