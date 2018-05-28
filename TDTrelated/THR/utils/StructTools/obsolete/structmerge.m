function S = structmerge(varargin)
%STRUCTMERGE join two structure arrays.
%   S = STRUCTMERGE(S1, KeyFields1, S2, KeyFields2) joins the two structure arrays S1
%   and S2 by synchronizing the set of fields given by cell arrays KeyFields1 and 
%   KeyFields2.
%   
%   S = STRUCTMERGE(S1, KeyFields, S2, KeyFields, ..., SN, KeyFieldsN) merges more 
%   than two structure arrays.
%
%   See also STRUCTFIELD, STRUCTSORT, STRUCTFILTER, STRUCTVIEW and STRUCTPLOT

%B. Van de Sande 28-02-2005

%------------------------------main program-----------------------------------
%Evaluate parameters ...
if (mod(nargin, 2) ~= 0), error('Wrong number of input parameters.'); end
NS    = nargin/2;
Sidx  = find(cellfun('isclass', varargin, 'struct'));
FNidx = find(cellfun('isclass', varargin, 'cell'));
if ~isequal(Sidx+1, FNidx) | (length(Sidx) ~= NS), error('Wrong input parameters.'); end
if (length(unique(cellfun('length', varargin(FNidx)))) ~= 1), error('Sets of keyfields must all have the same length.'); end

%Reorganizing input parameters ...
Structs   = varargin(Sidx);
KeyFields = varargin(FNidx);
for n = 1:NS,
    idx = Sidx(n); SNames{n} = inputname(idx);
    if isempty(SNames{n}), SNames{n} = sprintf('struct%d', n); end
end

%Merge structures ...
Args = vectorzip(Structs(1:2), SNames(1:2), KeyFields(1:2));
S = Merge2Structs(Args{:}, 'normal'); 
if (NS > 2), %Mutiple structures to merge ...
    for n = 3:NS, 
        Args = [Structs(n), SNames(n), KeyFields(n)];
        S = Merge2Structs(S, '', KeyFields{1}, Args{:}, 'multiple'); 
    end
end
    
%------------------------------------local functions-----------------------------
function S = Merge2Structs(S1, SN1, KF1, S2, SN2, KF2, Mode)
    
%Converting structures to cell arrays ... And checking the validity
%of the set of keyfields ...
[D1, FN1] = destruct(S1); [D2, FN2] = destruct(S2);
if ~all(ismember(KF1, FN1)) | ~all(ismember(KF2, FN2)), error('One of the set of keyfields isn''t valid.'); end

%Finding matching rows ... and assembling new table ...
%ColIdx1 = find(ismember(FN1, KF1)); 
%ColIdx2 = find(ismember(FN2, KF2)); 
N = length(KF1); ColIdx1 = zeros(1, N);
for n = 1:N, ColIdx1(n) = find(strcmp(FN1, KF1{n})); end
N = length(KF2); ColIdx2 = zeros(1, N);
for n = 1:N, ColIdx2(n) = find(strcmp(FN2, KF2{n})); end

List1 = D1(:, ColIdx1); List2 = D2(:, ColIdx2);
List = CAintersect(List1, List2); NElem = size(List, 1); 
D = cell(0); IncIdx1 = find(~ismember(FN1, KF1)); IncIdx2 = find(~ismember(FN2, KF2));
for n = 1:NElem,
    Entry   = List(n, :);
    RowIdx1 = find(CAismember(List1, Entry)); N1 = length(RowIdx1);
    RowIdx2 = find(CAismember(List2, Entry)); N2 = length(RowIdx2);
    
    P = genperms([N1, N2]); NPerms = size(P, 1);
    for p = 1:NPerms,
        idx1 = RowIdx1(P(p, 1)); idx2 = RowIdx2(P(p, 2)); 
        %NewElem = [D1(idx1, :), D2(idx2, IncIdx)];
        NewElem = [D1(idx1, ColIdx1), D1(idx1, IncIdx1), D2(idx2, IncIdx2)];
        D = [D; NewElem];
    end
end

%Duplicate fieldnames are avoided by adding the name of the structure to each fieldname ...
idx = find(~ismember(FN1, KF1));
if strcmpi(Mode, 'normal'), FN1 = AddFieldName(FN1(idx), SN1); 
else, FN1 = FN1(idx); end;
idx = find(~ismember(FN2, KF2)); %Remove keyfields of second structure ...
FN2 = AddFieldName(FN2(idx), SN2);
FN = [KF1, FN1, FN2]; %Keeping the original names of keyfields ...

%Conversion to structure-array ...
S = construct(D, FN);

%----------------------------------------------------------------------------------------
function D = CAintersect(CA1, CA2)

if ~iscell(CA1) | ~iscell(CA2), error('Wrong input arguments.'); end
if ~isequal(size(CA1, 2), size(CA2, 2)), error('Number of columns need to be the same.'); end

%Reduce both cell-arrays so that there elements are both unique ...
%This can safely be done with conversion to character strings, because comparisons are
%only done within the same table, so the column alignment problem doesn't present itself.
List1 = cv2str(CA1); List2 = cv2str(CA2);
[dummy, idx1] = unique(List1, 'rows'); [dummy, idx2] = unique(List2, 'rows');
CA1 = CA1(idx1, :); CA2 = CA2(idx2, :);

%The intersection is given by the common members ...
NRow1 = size(CA1, 1); NRow2 = size(CA2, 1);
if NRow1 > NRow2, 
    [NRow1, NRow2] = swap(NRow1, NRow2);
    [CA1, CA2]     = swap(CA1, CA2);
end
idx = []; for n = 1:NRow1, idx = [idx, find(CAismember(CA2, CA1(n, :)))]; end

D = CA2(idx, :);

%----------------------------------------------------------------------------------------
function boolean = CAismember(CA, Elem)

if ~iscell(CA) | ~iscell(Elem), error('Wrong input arguments.'); end
if ~isequal(size(CA, 2), size(Elem, 2)), error('Number of columns need to be the same.'); end
if (size(Elem, 1) ~= 1), error('Only be one element can be searched for at a time.'); end
if isempty(CA), boolean = []; return; end %For compliance with ISMEMBER.M ...
    
[NRow, NCol] = size(CA); boolean = logical(ones(NRow, 1));
for n = 1:NCol,
    classType = lower(class(CA{1, n}));
    if ~all(cellfun('isclass', CA(:, n), classType)), error('Invalid cell-array, columns need to be of same class.'); end
    switch classType
    case 'double', 
        CAV = cat(1, CA{:, n}); ElemV = cat(1, Elem{:, n});
        boolean = boolean & ismember(CAV, ElemV); %Numeric vector functionality ...
    case 'char', boolean = boolean & ismember(CA(:, n), Elem(:, n)); %Cell-array of string functionality ...
    otherwise, error(sprintf('Columns of type ''%s'' not yet implemented.', classType)); end
end

%----------------------------------------------------------------------------------------
function FN = AddFieldName(FN, Name)

iscol = (size(FN, 1) > 1);

NElem = length(FN);
Name = repmat([Name, '.'], NElem, 1);
FN   = cellstr([Name, char(FN)]);

if ~iscol, FN = FN'; end

%----------------------------------------------------------------------------------------