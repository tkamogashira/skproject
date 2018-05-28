function Vec = EDFDate2Vec(Date, Time)

%B. Van de Sande 29-04-2004

if nargin == 1, Time = []; end

try, 
    if isempty(Date) & (isempty(Time) | (Time == 0)), error('To catch block ...'); end
    
    %Date is a character string of the form DD-MMMYY or DDMMM-YY
    [Year, Month, Day] = datevec(strrep(Date, '-', ''), 1985);
    
    %Time is given by an integer representing the number of 10th's of
    %a second since midnight 
    Hour = floor(Time/36000); Time = rem(Time, 36000);
    Min  = floor(Time/600); Time = rem(Time, 600);
    Sec  = round(Time/10);
catch, [Year, Month, Day, Hour, Min, Sec] = deal(NaN); end

%Standard SGSR date vector (NOT MATLAB convention ...!)
Vec = [Day, Month, Year, Hour, Min, Sec];