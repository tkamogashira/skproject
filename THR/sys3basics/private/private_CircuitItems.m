function Items = private_CircuitItems(actx);
% private_CircuitItems - get circuit info by actual querying of TDT devices
% Sys3loadCircuit calls this helper function once and stores the result
% using private_circuitInfo, from which other function can access it.

%==
% List of different datatypes for item ParTag

ItemTypeList = {'Component' 'ParTable' 'SrcFile' 'ParTag'}; % List of Item types known to us.

dataTypes = {'DataBuffer' 'Integer' 'Logical' 'SingleFloat' 'CoefficientBuffer' 'Undefined' 'KonstantInteger' 'JConstantFloat'};
for ii = 1:length(ItemTypeList),
    itemtype = ItemTypeList{ii};
    Nitem = invoke(actx,'GetNumOf',itemtype); % # items of this type
    clear S;
    for jj = 1:Nitem,
        Name = invoke(actx,'GetNameOf',itemtype,jj);
        if isequal('ParTag', itemtype),
            tp = char(invoke(actx,'GetTagType', Name));
            if isequal('P', tp), tp = 'C'; end
            DataType = keywordmatch(tp, dataTypes);
            TagSize = invoke(actx,'GetTagSize', Name);
            S(jj) = collectInStruct(Name, DataType, TagSize);
        else, % not a ParTag: Name seems to be the only retrievable property
            S(jj) = collectInStruct(Name);
        end
    end
    if Nitem>0, 
        Items.(itemtype) = S;
    else,
        Items.(itemtype) = [];
    end
end


