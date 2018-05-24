function [b_dble, y_dble, acc_dble, z_dble, polyacc_dble] = convert2double(this,b,y,acc,z,polyacc)
%CONVERT2DOUBLE   

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

b_dble = fi(b, 'DataType', 'double');
y_dble = fi(y, 'DataType', 'double');
acc_dble = fi(acc, 'DataType', 'double');
z_dble = fi(z, 'DataType', 'double');
polyacc_dble = fi(polyacc, 'DataType', 'double');

% [EOF]
