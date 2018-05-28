function [Head, Tail] = SimpleGate(Head, Tail, Rise, Fall);
% SimpleGate - realization of gating prepared by gatingRecipes
%   [Head Tail] = SimpleGate(Head, Tail, Rise, Fall) applies
%   rising and falling ramps to Head and Tail portions of
%   vectors Head and Tail, respectively.
%   Rise and Fall are the struct variables returned by GatingRecipes,
%   or the Window their fields.
%   The gating is a simple, sample-wise, multiplication:
%       Head = Head.*Rise; Tail = Tail.*Fall;
%   The only special feature is a correction of the lengths
%   if they do not match. The following rules apply:
%    - the multiplication is restricted to the minimum of the
%      lengths of the two vectors.
%    - Head and Rise are aligned at their FIRST sample (left alignment)
%    - Tail and Fall are aligned at their LAST sample (right alignment)

if isstruct(Rise), Rise = Rise.Window; end;
if isstruct(Fall), Fall = Fall.Window; end;

NR = min(length(Rise), length(Head));
Head(1:NR) = Head(1:NR).*Rise(1:NR);

NF = min(length(Fall), length(Tail));
Tail(end-NF+1:end) = Tail(end-NF+1:end).*Fall(end-NF+1:end);


