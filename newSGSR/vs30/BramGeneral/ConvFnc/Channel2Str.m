function Str = Channel2Str(ds)
%CHANNEL2STR    convert channel information in dataset to string.
%   Str = CHANNEL2STR(ds) convert channel information in dataset to a 
%   character string.

%B. Van de Sande 07-05-2004

if (nargin ~= 1) || ~isa(ds, 'dataset')
    error('Only argument should be dataset.');
end

%EDF datasets ...
if strcmpi(ds.fileformat, 'edf')
    if (ds.dssnr == 2)
        Str = sprintf('DSS#M %d %s/DSS#S %d %s', ds.mdssnr, upper(ds.mdssmode), ...
            ds.sdssnr, upper(ds.sdssmode));
    elseif (ds.dssnr == 1)
        Str = sprintf('DSS#M %d %s', ds.mdssnr, upper(ds.mdssmode)); 
    else
        Str = 'None';
    end
%SGSR/Pharmington datasets ...
else
    switch ds.activechan
        case 0, Str = '1,2';
        case 1, Str = '1';
        case 2, Str = '2';
        otherwise, Str = 'None';
    end
end
