function out = head(in)
if isa(in, 'cell')
    out = in{1};
else
    out = in(1);
end
