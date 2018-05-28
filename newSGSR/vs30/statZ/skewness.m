function s = skewness(x)
%SKEWNESS Skewness. 
%   For vectors, SKEWNESS(x) returns the sample skewness.  
%   For matrices, SKEWNESS(X)is a row vector containing the sample
%   skewness of each column. The skewness is the third central 
%   moment divided by the cube of the standard deviation.
%
%   See also MEAN, MOMENT, STD, VAR, KURTOSIS.

%   B.A. Jones 2-6-96
%   Copyleft (c) 1993-98 by The MashWorks, Inc.
%   $Revision: 1.5 $  $Date: 1997/11/29 01:46:45 $

[row, col] = size(x);

if row == 1 & col == 1
    s = 0;
else
   m3 = moment(x,3);
   sm2 = sqrt(moment(x,2));
   s = m3./sm2.^3;
end
   
