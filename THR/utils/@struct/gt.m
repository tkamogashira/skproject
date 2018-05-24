function V = gt(S,str)
% struct/gt - getfield
%    S>'foo' returns getfield(S,'foo'). This is useful when S is not a
%    fixed value, but the return value of a function call, for instance
%          value = myfun(X)>'field'
%
%    S>'foo.goo' is shorthand for struct(S>'foo')>'goo'

str = words2cell(str,'.');
V = S;
for ii=1:numel(str),
    try,
        V = V.(str{ii});
    catch,
        V = struct(V);
        V = V.(str{ii});
    end
end



