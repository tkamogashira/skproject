function mkEDFvisible
%MKEDFVISISBLE  makes all EDF datafiles visible in current browsing directory
%   MKEDFVISIBLE makes all EDF datafiles visible in the current browsing directory by adding
%   an empty file for each datafile with the same name as the datafile but with extension 
%   '.LOG'.

%B. Van de Sande 08-10-2003

d = dir([bdatadir '\*.dat']);

N = length(d);
for n = 1:N,
    if isEDF(d(n).name),
        [dummy, FileName] = fileparts(d(n).name); FileName = lower(FileName);
        FullFileName = [bdatadir '\' FileName '.log'];
        if exist(FullFileName), warning(sprintf('%s.log already exist.\n', FileName)); 
        else    
            fid = fopen(upper(FullFileName), 'wt');
            if fid < 0, error(sprintf('Could not generate %s.log', FileName)); end
            fprintf(fid, '');    
            fclose(fid);
        end    
    end    
end