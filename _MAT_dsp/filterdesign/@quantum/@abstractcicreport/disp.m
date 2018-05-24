function disp(this)
%DISP   Display this object.

%   Author(s): V. Pellissier
%   Copyright 2005 The MathWorks, Inc.

dispheader(this);
dispinfo(this.Input,'Input: ');
dispinfo(this.Output,'Output: ');

nsec = this.nsections;
% Integrator
for i=1:nsec,
    dispinfo(this.(['IntSect',num2str(i)]),['IntSect',num2str(i),': ']);
end
% Comb
for i=1:nsec,
    dispinfo(this.(['CombSect',num2str(i)]),['CombSect',num2str(i),': ']);
end


% [EOF]
