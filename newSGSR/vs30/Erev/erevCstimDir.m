function sd=ErevCstimdir;
% EREVCSTIMDIR - returns directory for cstim files as char string
if inLeuven,
   sd = 'C:\usr\Marcel\data\Erev';
elseif inUtrecht,
   sd = 'D:\SGSRwork\ExpData\Leuven\graspEREV';
else, error('no default erev directory');
end
