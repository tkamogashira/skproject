function SPL = GetSPL(ds)
%GETSPL get sound pressure level for dataset
%   SPL = GETSPL(ds) returns the sound pressure level in dB for the dataset ds.
%   The SPL is returned as a matrix with the number of rows defined by the total 
%   number of subsequences and with the same number of columns as active channels 
%   used in the collection of data.

%B. Van de Sande 15-03-2004

NChan   = 2 - sign(ds.dachan);
NSub    = ds.nsub;
NSubRec = ds.nrec;

SPL = repmat(NaN, NSub, NChan);

%EDF datasets: SPL is always a field of the StimParam structure except for TH and CALIB
%datasets. It is a scalar for datasets with only one active channel, and a two-element
%row-vector for datasets with two active channels. If the SPL is varied for a dataset then
%SPL is a matrix with the same number of rows as total number of subsequences. If not 
%completely recorded then the SPL values aren't set to NaN. If not applicable for a dataset
%then the value is set to NaN.
if strcmpi(ds.FileFormat, 'EDF'), 
    if ~any(strcmpi(ds.ExpType, {'TH', 'CALIB'}))
        if (ds.indepnr == 1),
            if size(ds.StimParam.SPL, 1) > 1,
                SPL(1:NSubRec, :) = ds.StimParam.SPL(1:NSubRec, :);
            else,    
                SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
                SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
            end
        elseif (ds.indepnr == 2), %NOG NA TE KIJKEN ...
            if (size(ds.StimParam.SPL, 1) > 1), 
                EDFIndepVar = ds.EDFIndepVar;
                VarNames = {EDFIndepVar.ShortName};
                idx = find(ismember(VarNames, 'Level'));
                if isempty(idx),
                    SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
                    SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
                else,
                    SPL(1:NSubRec, 1:NChan) = repmat(ds.EDFIndepVar(idx).Values(1:NSubRec), 1, NChan); 
                end    
            else,
                SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
                SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
            end    
        end    
    end    
%SGSR datasets: SPL is always a field of the StimParam structure and is given as a 
%scalar for datasets with only one active channel, and a two-element row-vector for
%datasets with two active channels ...
elseif strcmpi(ds.FileFormat, 'SGSR'),
    if any(strcmpi(ds.StimType, {'NRHO', 'ARMIN', 'BN', 'BERT'})),
        SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
        SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
    end
%IDF/SPK datasets: For SPL and NSPL datasets the SPL-settings are found as a column-
%vector in 'IndepVar.Values'. For appropriate other datasets the SPL is found in the field
%'indiv.stim{}.spl'. Again given as a scalar for datasets with only one active channel, and
%a two-element row-vector for datasets with two active channels. NTD-datasets are an 
%exception to this rules and the SPL can be extracted in the same way as with SGSR datasets ...
elseif strcmpi(ds.FileFormat, 'IDF/SPK'),
    if any(strcmpi(ds.StimType, {'ITD', 'FS', 'FSLOG', 'BFS', 'FM', 'LMS', 'BB', 'CFS', 'CTD'})),
        SPL(1:NSubRec, 1) = ds.StimParam.indiv.stim{1}.spl;
        SPL(1:NSubRec, NChan) = ds.StimParam.indiv.stim{end}.spl;
    elseif any(strcmpi(ds.StimType, {'SPL', 'NSPL'})), 
        SPL(:, 1:NChan) = repmat(ds.indepval, 1, NChan);    
    elseif any(strcmpi(ds.StimType, 'NTD')),
        SPL(1:NSubRec, 1) = ds.StimParam.SPL(1); 
        SPL(1:NSubRec, NChan) = ds.StimParam.SPL(end);
   end    
end