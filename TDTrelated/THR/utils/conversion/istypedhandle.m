function ith=istypedhandle(h, Type);
% istypedhandle - true for handle of a specified type
%   istypedhandle(H, 'Foo') returns True if H is a handle if type Foo, as
%   determined by get(H,'type'). The type specification Foo is case
%   insensensitive, but may not be abbreviated.
%
%   See also ISHANDLE, isSingleHandle, GET.

Type;
ith = false(size(h));
if isempty(h),
    return;
end
ih = ishandle(h);
Types = cellify(get(h(ih),'type'));
if isequal({[]}, Types),
    return;
end
ihit = strmatch(lower(Type), lower(Types), 'exact');
ith(ihit)=true;



