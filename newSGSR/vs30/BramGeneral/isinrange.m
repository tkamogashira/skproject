function boolean = isinrange(Value, Range)

if (~isequal(size(Value),[1 2])) || ...
        (Value(1) > Value(2)) || ...
        (Value(1) < Range(1)) || ...
        (Value(1) > Range(2))
    boolean = false;
else
    boolean = true;
end
