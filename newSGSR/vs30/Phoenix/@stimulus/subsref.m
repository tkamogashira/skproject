function SR = subsref(S, subscript);
% stimulus/subsref - subsref for stimulus objects
%   ST.foo returns virtual field of stimulus object ST.
%   valid fieldnames of stimulus objects are:
%   name, waveform, DAshot, presentation, createdby, struct.
%   
%   Note: S.struct is the same as struct(S) but, unlike
%   the latter functional form, S.struct can be referenced
%   recursively as in S.struct.DAshot(2).HardwareSettings.
%
%   See also Stimulus.

if length(subscript)>1, % handle by recursion
   S = subsref(S, subscript(1));
   SR = subsref(S, subscript(2:end));
   return;
end

% -----------single-level subscript from here
trivial = 1;
switch subscript.type,
case '()', 
   SR = builtin('subsref', S, subscript);
case '{}', error('S{...} not defined for paramset objects.');
otherwise, trivial = 0;
end
if trivial, return; end

% -----------single field reference from here
if numel(S)>1,
   error('Fields reference of stimulus arrays is an error.'); 
end

fn = subscript.subs; % virtual fieldname
switch lower(fn),
case {'name'}, SR = S.name;
case {'chunk'}, SR = S.chunk;
case {'waveform'}, SR = S.waveform;
case {'dashot'}, SR = S.DAshot;
case {'presentation'}, SR = S.presentation;
case {'globalinfo'}, SR = S.globalInfo;
case {'createdby'}, SR = S.createdBy;
case {'struct'}, SR = struct(S);
otherwise,
   error(['Invalid virtual field name ''' fn ''' of stimulus object.']);
end
   
