function h=fhandle(nam)
% FHANDLE - convert filename to function handle
%   FHANDLE('Foo') is the same as @Foo.
%   FHANDLE(@Foo) returns @Foo.

if ischar(nam),
    eval(['h=@' nam ';']);
elseif isa(nam, 'function_handle'),
    h = nam;
else,
    error(['Cannot convert a ' class(nam) ' into a function handle.'])
end









