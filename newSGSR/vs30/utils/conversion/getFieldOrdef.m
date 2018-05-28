function fv = getFieldOrDef(s,fn,def);
% GETFIELDORDEF - return field of struct or default if field is not in struct
if isfield(s,fn), fv = getfield(s,fn);
else, fv = def;
end