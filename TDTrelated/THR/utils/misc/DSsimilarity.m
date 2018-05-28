function IDout = DSsimilarity(DSs,simfields,nest)
% DSsimilarity - check whether datasets are similar in specific fields
%   ID = DSsimilarity(DSs,fields) checks for dataset arrays "DSs"
%   whether they are equal in "DS.fields". An error message appears when
%   datasets are dissimilar, unless an output argument is queried. Both the
%   error and the output indicate where the datasets are dissimilar.
%
%   ID = DSsimilarity(DSs,fields,nested) is similar, but with nested
%   fieldnames. This gives a more specific query into the dataset object.
%
%   ID = DSsimilarity(DSs,'all') and DSsimilarity(DSs,'all',nested) check
%   similarity for all fields and returns the fieldnames that are different
%   in the error message.
%
%   See also structCompare.
%

% Defaults
if nargin < 3
    nest = ''; % empty field
end
if nargin < 2 || isempty(simfields)
    simfields = 'all'; % all fields    
end

% Comparison of the datasets
nDSs = numel(DSs);
for ii = 1:nDSs
    if ~isempty(nest) % nested
        if ~strcmpi(simfields,'all') % not all
            SPii = structpart(DSs(ii).(nest),simfields); % struct part index ii
        else % all
            SPii = struct(DSs(ii).(nest)); % struct index ii
        end
    else % not nested
        if ~strcmpi(simfields,'all') % not all
            SPii = structpart(DSs(ii),simfields); % struct part index ii
        else % all
            SPii = struct(DSs(ii)); % struct index ii
        end
    end
    for jj = ii:nDSs % only one-sided similarity matrix necessary, it is more or less mirror symmetric
        if ~isempty(nest) % nested
            if ~strcmpi(simfields,'all') % not all
                SPjj = structpart(DSs(jj).(nest),simfields); % struct part index jj
            else % all
                SPjj = struct(DSs(jj).(nest)); % struct index jj
            end
        else % not nested
            if ~strcmpi(simfields,'all') % all
                SPjj = structpart(DSs(jj),simfields); % struct part index jj
            else % not all
                SPjj = struct(DSs(jj)); % struct index jj
            end
        end
        simmat{ii,jj} = structCompare(SPjj,SPii); % cell array representing "similarity matrix"
    end
end
Tsimmat = simmat.'; % transpose similarity matrix
simmat(~cellfun(@isempty,Tsimmat)) = Tsimmat(~cellfun(@isempty,Tsimmat)); % make matrix two sided

% Generate error message
[indI indJ] = find(~cellfun(@isempty,simmat)); % row and column indices that are non-empty and thus need to be returned in error message
IDstruct = emptystruct('Rec','IsDissimFromRec','InField'); % empty IDstruct
if numel(indI) ~=0 % if dissimilar stimulus conditions have been found
    mssgstr = {}; % empty error message cell array
    uindJ = unique(indJ); % unique columns from similarity matrix
    for ii = 1:numel(uindJ)
        qindx = indJ == uindJ(ii); % logical index to current similarity matrix column
        ind = find(qindx); % normal index to current similarity matrix column
        dissimfields = simmat{indI(ind(1)),uindJ(ii)}; % first dissimilar struct for comparison with the rest
        if numel(ind) > 1 % only when more than 1 element of this column is dissimilar
            for jj = 2:numel(ind)
                newfields = simmat{indI(ind(jj)),uindJ(ii)}; % additional dissimilar struct
                dissimfields = structjoin(dissimfields,newfields); % join the two dissimilar structs
            end
        end
        for jj = 1:nDSs
            helpvar1{jj} = DSs(jj);
        end
        helpvar2 = cellfun(@(DS) DS.ID.iDataset,{helpvar1{indI(qindx)}}); % help variable to extract data from cell array
        % Create error message cell array
        mssgstr{end+1} = ['Recording ' ...
            int2str(DSs(uindJ(ii)).ID.iDataset) ...
            ' is dissimilar from recording(s) ' ...
            strrep(strrep(strrep(int2str(helpvar2),'   ','  '),'  ',' '),' ','/') ...
            ' in field(s) ' ...
            cell2words(fieldnames(dissimfields).','/') ...
            '\n'];
        IDstruct(end+1).Rec = DSs(uindJ(ii)).ID.iDataset;
        IDstruct(end).IsDissimFromRec = helpvar2;
        IDstruct(end).InField = fieldnames(dissimfields);
    end
    mssgstr{1} = [' ' mssgstr{1}]; % remove display offset in error message
end

% Optional output argument / error message
if nargout > 0
    IDout = IDstruct;
elseif ~isempty(IDstruct),
    error('DSSimilarityCheck:DissimilarDS',cell2words(mssgstr)) % return multi-line error message
end


