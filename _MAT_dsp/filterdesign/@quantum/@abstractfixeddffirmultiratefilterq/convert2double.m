function [b_dble, y_dble, acc_dble, z_dble, tapsum_dble] = convert2double(this,b,y,acc,z,tapsum)
%CONVERT2DOUBLE   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

b_dble = fi(b, 'DataType', 'double');
y_dble = fi(y, 'DataType', 'double');
acc_dble = fi(acc, 'DataType', 'double');
z_dble = fi(z, 'DataType', 'double');

% attach full precision fimath
F = fimath;
b_dble.fimath = F;
y_dble.fimath = F;
acc_dble.fimath = F;
z_dble.fimath = F;

tapsum_dble = [];
if nargin>5
   tapsum_dble = fi(tapsum, 'DataType', 'double');
   tapsum_dble.fimath = F;
end 

% [EOF]
