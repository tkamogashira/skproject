function boolean = compare(Type, TargetItem, Item)

boolean = logical(0);

%Wegens snelheidsoverwegingen gecommentarieerd ...
%if ~strcmp(class(TargetItem), class(Item)), return; end

switch Type
case '=', boolean = isequal(TargetItem, Item);
case '<'
    if isnumeric(TargetItem), boolean = (TargetItem < Item);
    elseif isstruct(TargetItem)
        FNames  = fieldnames(TargetItem);
        NFields = length(FNames);
        
        for FieldNr = 1:NFields
            FieldName = FNames{FieldNr};
            TargetValue = getfield(TargetItem, FieldName);
            Value       = getfield(Item, FieldName);
            
            Class = class(Value);
            switch Class
            case 'double'    
                if TargetValue < Value, boolean = logical(1); break; 
                elseif TargetValue > Value, break; end    
            case {'char', 'struct'}
                if Compare('<', TargetValue, Value), boolean = logical(1); break;
                elseif Compare('>', TargetValue, Value), break; end
            end    
        end
    elseif ischar(TargetItem)
        LenDiff  = length(Item) - length(TargetItem);
        CharDiff = [TargetItem zeros(1, LenDiff)] - [Item zeros(1, -LenDiff)];
        iZero    = find(CharDiff == 0);
        CharDiff(iZero) = [];
        if ~isempty(CharDiff) & CharDiff(1) < 0, boolean = logical(1); end
    end    
case '>'
    if isnumeric(TargetItem), boolean = (TargetItem > Item);
    elseif isstruct(TargetItem)
        FNames  = fieldnames(TargetItem);
        NFields = length(FNames);
        
        for FieldNr = 1:NFields
            FieldName = FNames{FieldNr};
            TargetValue = getfield(TargetItem, FieldName);
            Value       = getfield(Item, FieldName);
            
            Class = class(Value);
            switch Class
            case 'double'    
                if TargetValue > Value, boolean = logical(1); break; 
                elseif TargetValue < Value, break; end
            case {'char', 'struct'}
                if Compare('>', TargetValue, Value), boolean = logical(1); break;
                elseif Compare('<', TargetValue, Value), break; end
            end    
        end
    elseif ischar(TargetItem)
        LenDiff  = length(Item) - length(TargetItem);
        CharDiff = [TargetItem zeros(1, LenDiff)] - [Item zeros(1, -LenDiff)];
        iZero    = find(CharDiff == 0);
        CharDiff(iZero) = [];
        if ~isempty(CharDiff) & CharDiff(1) > 0, boolean = logical(1); end
    end    
end    
