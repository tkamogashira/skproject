function Cop = ggcopy(n,newtagname);
% ggcopy - copy uicontrol into struct to be pasted with ggpaste

if nargin<2, newtagname = ''; end

% obtain struct with property fields
global GG;
N = length(n); 
if N>1, % multiple, recursive, call
   Cop = cell(1,N);
   jj=0;
   for ii=n,
      jj = jj+1;
      Cop{jj} = ggcopy(ii);
   end
   return;
end
%--------------------single UI item from here---------
Cop = get(GG(n));
if ~isempty(newtagname), Cop.Tag = newtagname; end;

ISMENU = 0;
if isequal(Cop.Type,'uimenu'),
   if ~isequal(Cop.Parent, GG(1)), % don't copy menuitems
      Cop = struct('Type', 'void');
      return;
   else,
      ISMENU = 1;
      menuItems = Cop.Children.'; %row vector
   end
end
% now modify Cop in order to use it for creating a uicontrol
% on a different figure
if ISMENU,
   Nitem = length(menuItems);
   Cop = CleanUpFields(Cop,1);
   Cop.Children=cell(min(1,Nitem),N);
   for ii=1:Nitem,
      Cop.Children{ii} = get(menuItems(ii));
      Cop.Children{ii} = CleanUpFields(Cop.Children{ii},1);
   end
else,
   Cop = CleanUpFields(Cop,1);
end

%---locals-------------
function S=CleanUpFields(S,Herodes);
S = Try2RmField(S, 'Extent');
S= Try2RmField(S, 'Parent');
S= Try2RmField(S, 'BeingDeleted');
% Cop= Try2RmField(Cop, 'Type'); leave this; only remove when pasting!
% move position field to end to avoid complaints about unit/pos order
pos = S.Position; 
S = Try2RmField(S, 'Position');
S.Position = pos;
if Herodes, S = Try2RmField(S, 'Children'); end;

function S = Try2RmField(S, fn);
if isfield(S,fn),
   S = RmField(S, fn);
end


