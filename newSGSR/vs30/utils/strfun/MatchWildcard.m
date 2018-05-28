function matches = MatchWildcard(Target, WildCard, CaseMatch);
% MatchWildcard - checks wildchard matching
AST = 1; QUE = 2; wcStr = '*?';
if nargin<3,
   CaseMatch = 0;
end
if ~CaseMatch,
   Target = lower(Target);
   if isstr(WildCard),
      WildCard = lower(WildCard);
   end
end

%if isempty(Target),
%   matches = 0;
%   return;
%end

if isempty(WildCard),WildCard = '*';  end
if isstr(WildCard), % parse it and put in cell array
   iw = 0; st = 0;
   for c = WildCard,
      switch c
      case {'*', '?'},
         iw = iw+1;
         if c=='*', WC{iw} = AST; else, WC{iw} = QUE; end;
         st = 0;
      otherwise,
         if ~st, % initialize string element
            iw = iw+1;
            WC{iw} = '';
         end
         WC{iw} = [WC{iw} c];
         st = 1;
      end
   end
   WildCard = WC;
end

% from here, WildCard is non-empty cell array
Nw = length(WildCard);

LenT = length(Target);
if Nw==1,
   W = WildCard{1};
   matches = isequal(AST,W) ...
      | (isequal(QUE,W) & (length(Target)==1)) ...
      | isequal(Target,W);
else % Nw>2
   W1 = WildCard{1}; L1 = length(W1);
   if isstr(W1), % test if Target begins with W1 and use recursive call
      if isempty(strmatch(W1, Target)), matches = 0;
      else, matches = matchWildCard(Target((L1+1):end), {WildCard{2:end}},1);
      end
   elseif W1==QUE, % ignore first char and test the remainder
      matches = matchWildCard(Target(2:end), {WildCard{2:end}},1);
   else % W1 is asterisk; test for occurences of 2nd W
      W2 = WildCard{2}; L2 = length(W2);
      if isstr(W2),
         if L2>LenT, % Target cannot contain W2 (finstr is symmetric, test is not: "W2 in Target")
            matches = 0;
            return;
         end
         F2 = findstr(Target, W2);
         for f2=F2,
            f21 = f2+1;
            matches = matchWildCard(Target(f21:end), {WildCard{[3:end]}},1);
            if matches, return; end;
         end
         matches = 0;
      else, % W2 is irrelevant; remove it
         matches = matchWildCard(Target, {WildCard{[1, 3:end]}},1);
      end
   end
end
















