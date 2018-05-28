function Struct = EnhanceIndepVar(Struct)

NElem = length(Struct);
for N = 1:NElem
    Scale = getfield(Struct, {N}, 'Scale');
    switch Scale
    case 1, Struct = setfield(Struct, {N}, 'Scale', 'linear');
    case 2, Struct = setfield(Struct, {N}, 'Scale', 'logaritmic');
    end
    
    Order = getfield(Struct, {N}, 'Order');
    switch Order
    case 1, Struct = setfield(Struct, {N}, 'Order', 'ascending');
    case 2, Struct = setfield(Struct, {N}, 'Order', 'descending');
    case 3, Struct = setfield(Struct, {N}, 'Order', 'random');
    end    
end