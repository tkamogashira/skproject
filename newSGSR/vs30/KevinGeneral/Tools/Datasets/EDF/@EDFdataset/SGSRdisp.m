function ArgOut = SGSRdisp(ds)
%SGSRdisp overloaded for EDF dataset objects

%B. Van de Sande 08-10-2003

if ~strcmp(ds.dataset.ID.FileFormat, 'EDF'), error('No EDF dataset object.'); end

SP = struct(ds.dataset.Stimulus.StimParam);
s = local_struct2str(SP);

if nargout > 0, ArgOut = s; else disp(s); end

%--------------------------------------------local function-------------------------------------------
function s = local_struct2str(S)

if isfield(S, 'dummy'), S = rmfield(S, 'dummy'); end

FNames   = fieldnames(S);
NFields  = length(FNames);
MaxWidth = 0;
FVC      = cell(0);
for n = 1:NFields,
   FN = FNames{n};
   FV = getfield(S, FN);
   MaxWidth = max(MaxWidth, length(FN));
   
   if isstruct(FV), 
       FVs = local_struct2str(FV);
   elseif isnumeric(FV), FVs = mat2str(FV);
   elseif ischar(FV), FVs = ['''' FV ''''];
   elseif iscellstr(FV), FVs = formatcell(FV, {'{', '}'}, ',');
   else, FVs = char(FV); end
   
   if (size(FVs, 1) == 1) & (length(FVs) > 40), FVs = [FVs(1:35) ' .. ' FVs(end)]; end
   
   FVs = [[':'; repmat(' ', size(FVs, 1)-1, 1)], FVs];
   FVC{n, 1} = FVs;
end

FNC = cell(0);
for n = 1:NFields,
   FN = FNames{n};
   Len = size(FVC{n, 1} , 1);
   FNC{n, 1} = [fixlenstr(FN, MaxWidth+3, 1); repmat(blanks(MaxWidth+3), Len-1, 1)];
end

s = [char(FNC) char(FVC)];