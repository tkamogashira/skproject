function [table, chi2, p] = crosstab(col1,col2)
%CROSSTAB Cross-tabulation of two column vectors.
%   CROSSTAB(COL1,COL2) takes two vectors of positive integers
%   and returns a matrix, TABLE, of crosstabs. Element (i,j) of TABLE
%   contains the count of all instances where COL1 = i and COL2 = j.
%   [TABLE, CHI2, P] = CROSSTAB(COL1,COL2) also returns the chisquare
%   statistic, CHI2, for testing the independence of the rows and 
%   columns TABLE. The scalar, P, is the significance level of the test.
%   Values of P near zero cast doubt on the assumption of independence 
%   of the rows and columns of TABLE.

%   B.A. Jones 3-5-95
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 2.5 $  $Date: 1997/11/29 01:45:10 $

if min(size(col1)) ~= 1 | min(size(col2)) ~= 1
  error('Requires only vector input arguments.');
end

k = find(isnan(col1) | isnan(col2));
col1(k) = [];
col2(k) = [];

if any(col1 ~= round(col1)) | any(col1 < 1) | any(col2 ~= round(col2)) | any(col2 < 1),
   error('Requires the inputs to be positive integers.');
end 

m = length(col1);
n = length(col2);
if m ~= n
   error('Input vectors must have the same number of elements.');
end

c1max = max(col1);
c2max = max(col2);

table = zeros(c1max,c2max);

for k = 1:n
   table(col1(k),col2(k)) = table(col1(k),col2(k)) + 1;
end
 
rowtot = sum(table);
rowtot = rowtot(ones(c1max,1),:);
coltot = sum(table')';
coltot = coltot(:,ones(c2max,1));

expected = coltot .* rowtot ./ n;

chi2 = sum(sum((table - expected).^ 2 ./ expected));

df = (c1max - 1) .* (c2max - 1);

p = 1 - chi2cdf(chi2,df);
