function ib = betwixt(X, A, B);
% BETWIXT - test if value is between two given values
%    BETWIXT(X,A,B) or BETWIXT(X, [A B]) returns true for those elements X(k) of X 
%    for which A<X(k)<B.
%
%    For a combination of array and matrix inputs for X,A,B, these three
%    input arguments are "SameSized" prior to testing the inequality. In
%    such "mixed cases", it is best to use the Betwixt(X,A,B) syntax,
%    as opposed to the Betwixt(X,[A B]) syntax, which can be confusing.
%
%    Example
%      Betwixt((1:3), (-1:2)', 2.5)
%      This tests, in matrix form:
%         (-1<1<2.5)  (-1<2<2.5)  (-1<3<2.5)   
%         ( 0<1<2.5)  ( 0<2<2.5)  ( 0<3<2.5)   
%         ( 1<1<2.5)  ( 1<2<2.5)  ( 1<3<2.5)   
%         ( 2<1<2.5)  ( 2<2<2.5)  ( 2<3<2.5)   
%
%    See also SamSize CLIP.


error(nargchk(2,3,nargin));
if nargin<3,
   B = A(:,end);
   A = A(:,1);
end
if isempty(X), 
    ib = false(size(X)); 
else,
    [X,A,B] = sameSize(X,A,B);
    ib = (X>A) & (X<B);
end






