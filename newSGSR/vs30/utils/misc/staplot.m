function legh = staplot(S, f1, f2, fpart, plotArg)
% staplot - simple structplot-like utility
%   exampleusage: 
%      staplot(S, 'cf', 'Drate') % all data
%      staplot(S, 'cf', 'Drate', 'Ear') % use diff marker for each S.Ear char value
%      staplot(S, 'cf', 'Drate', {'th' 10}) % partition th values in 10 eq-spaced intervals 
%      staplot(S, 'cf', 'Drate', {'th' [-inf 10 20 30 inf]}) % partition th values according to Edges vector
%

if nargin<4, fpart = ''; end
if nargin<5, plotArg = ''; end
figure(gcf); 
if isempty(plotArg), %clf;
else, hold on;
end

if ~isempty(fpart), % plot partitions one by one using recursion
   partID = fpart;
   if iscell(partID), partID = partID{1}; end
   pclass = class(getfield(S(1), partID));
   switch pclass
   case 'char', % partID is fieldname of char-valued field; each possible value is a category
      part = eval(['{S.' partID '}']); % all values in cellstr
      partVal = unique(part);
      for ii=1:length(partVal),
         iselect = strmatch(partVal(ii), part);
         staplot(S(iselect), f1, f2, '', [ploma(ii) ploco(ii)]);
      end
      legend(partVal);
   case 'double', % partID is fieldname of numerical-valued field; partition the range of values
      part = eval(['[S.' partID ']']); % all values in num array
      partInfo = fpart{2};
      if length(partInfo)==1, % partInfo is # of partitions
         Npart = partInfo;
         [minVal, maxVal] = minmax(part);
         Edges = linspace(minVal, maxVal, Npart+1);
      else, % partInfo is vectot with Edges
         Edges = partInfo;
      end
      isegment = inSegment(part, Edges);
      for ii=1:length(isegment),
         iselect = isegment{ii};
         staplot(S(iselect), f1, f2, '', [ploma(ii) ploco(ii)]);
         legendStr{ii} = [num2sstr(Edges(ii)) '<' partID '<' num2sstr(Edges(ii+1))];
      end
      legh = legend(legendStr);
   otherwise error NYI
   end
   return;
end

% ----------no partition from here -------------
X = eval([ '[S.'  f1 ']' ]);
Y = eval([ '[S.'  f2 ']' ]);
if isempty(plotArg), plotArg = 'bo'; end
plot(X,Y,plotArg);
xlabel(f1);
ylabel(f2);



