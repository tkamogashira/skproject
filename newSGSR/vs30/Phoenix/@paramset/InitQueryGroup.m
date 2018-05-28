function S = InitQueryGroup(S, Name, Pos, Title, TitlePos);
% paramset/InitQueryGroup - initialize a group of parameter queries
%   S = InitQueryGroup(S, groupName, [X,Y,W,H], Title) initializes a group of
%   parameter queries for paramset object S. GroupName must be a valid
%   MatLab variable name (see VarName). Default Title equals Name.
%   The special position [X Y 1e6-M H] means that the frame extends
%   to M points from the right border of the figure. Note that the figure
%   size at creation time og the group might not equal the final size.
%
%   In a OUI constructed from S, query groups show up as title frames.
%   X and Y specify the position in points of this frame on the OUI.
%   W and H specify the width and height of the frame in points.
%   Note: contrary to MatLab conventions, Y is measured from the TOP 
%   of the OUI.
%
%   Any queries subsequently added to S will join the most recently
%   initialized query group. Their positions are specified relative to
%   the frame position.
%
%   In InitQueryGroup(S, groupName, [X,Y,W,H], Title, [Xtitle, Ytitle]),
%   the positions of the frame title is also specified re the position
%   of the frame istself. The default title position is [1]
%
%   See also Paramset, Paramset/AddParam, Paramset/AddQuery, paramOUI.

OUImargin = 10; % points margins 

if nargin<4, Title = Name; end % default title position re frame
if nargin<5, TitlePos = [15 -10]; end % default title position re frame

if  nargout<1, 
   error('No output argument using InitQueryGroup. Syntax is: ''S = InitQueryGroup(S,...)''.');
elseif isvoid(S),
   error('Queries may not be added to a void paramset object.');
elseif ~isvarname(Name),
   error(['Group name must be valid varname: ''' Name ''' is not.']);
end

% check if group of that name already exist
if ~isempty(S.OUI.group),
   if ismember(lower(Name), {S.OUI.group.Name}),
      error(['A group named ''' Name ''' already exists in paramset ''' S.Name  '''.']);
   end
end
group = CollectInstruct(Name, Pos, Title, TitlePos);
S.OUI.group = [S.OUI.group group];
% make sure figure is big enough to hold this group
Xmax = sum(Pos([1 3])); Ymax = sum(Pos([2 4]));
S.OUI.minFigSize = max(S.OUI.minFigSize, OUImargin+[Xmax,Ymax]);






