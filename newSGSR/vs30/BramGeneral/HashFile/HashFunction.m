function Index = HashFunction(Key, MaxIndex)
%HASHFUNCTION   general hashfunction
%   Index = HASHFUNCTION(Key, MaxIndex)
%   Input parameters:
%   Key      : variable that is used to uniquely identify data, usually stored on disk. This variable can 
%              be one of the following MATLAB classes: double, char, struct, cell. Container variables, such 
%              as struct and cell, can be nested.
%   MaxIndex : this hashfunction generates an integer number between 1 and MaxIndex. This number is always the
%              same for a given key.
%
%   See also PUTINHASHFILE, GETFROMHASHFILE, RMFROMHASHFILE, DELETEHASHFILE

%Parameters nagaan ...
if nargin ~= 2, error('Wrong number of input parameters'); end

if isempty(Key), error('Key cannot be empty'); end
if ~isnumeric(MaxIndex) | (ndims(MaxIndex) ~= 2) | (length(MaxIndex) ~= 1) | (MaxIndex <= 0)
    error('Second argument should be scalar with maximum index');
end

Index = 1;

%Naargelang klasse van Key andere hashing toepassen ...
switch class(Key)
case {'double', 'char'}
    Index = Index + floor(sum(double(Key(:))));
case 'struct'
    [NRow, NCol] = size(Key);
    
    for r = 1:NRow
        for c = 1:NCol
            FNames  = fieldnames(Key);
            NFields = length(FNames);
            
            for n = 1:NFields
                Index = Index + (n * HashFunction(getfield(Key, {r,c}, FNames{n}), MaxIndex));
            end
        end
    end
case 'cell'
    if iscellstr(Key), 
        Key = char(Key{:}); 
        Index = Index + HashFunction(Key(:), MaxIndex); 
    else 
        [NRow, NCol] = size(Key);
        
        for r = 1:NRow
            for c = 1:NCol
                Index = Index + ((r+c) * HashFunction(Key{r,c}, MaxIndex));
            end
        end
    end    
otherwise, error(sprintf('%s type of class not implemented', class(Key))); end    

%Index terugbrengen tussen 1 en MaxIndex ...
Index = mod(Index, MaxIndex) + 1;