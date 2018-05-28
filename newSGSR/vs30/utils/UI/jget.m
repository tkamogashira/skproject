function yy = jget(j);
% JGET - debugged GET for java objects
%    get on java objects creshes because of unimplemented features in MatLab
%    JGET filters out the offending properties.
%    It is assumed that SET works without any problem on these objects.

BugProps = {'HelpMenu' 'TearOff' 'DefaultButton' 'DefaultCapable'};
% use SET to get list of properties
qq=set(j);
PropList = fieldnames(qq);
y = [];
for ii=1:length(PropList),
   prop = PropList{ii};
   if ismember(prop, BugProps), continue; end % skip offending props
   val = get(j, prop);
   y = setfield(y, prop, val);
end

if nargout<1, % display
   disp(y);
else, % return
   yy = y;
end
