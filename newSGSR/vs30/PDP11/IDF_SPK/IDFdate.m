function datestr=IDFdate(dateArray)

% function datestr=IDFdate(dateArray);

months = {'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun'  ...
          'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec'};

day = num2str(dateArray(1));
month = months{dateArray(2)};
year = num2str(dateArray(3));
hour = num2str(dateArray(4));
minute = num2str(dateArray(5));
if (length(minute)==1)
    minute=['0' minute];
end
second = num2str(dateArray(6));
if (length(second)==1)
    second=['0' second];
end
sp = ' ';
at = ' ';
cl = ':';
mn = '-';

datestr = [day mn month mn year sp at sp hour cl minute cl second];
