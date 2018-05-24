function [p, v] = thisinfo(this)
%THISINFO   Get the information for this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

[p,int,comb,v,intv,combv] = cic_info(this);
p = [p, comb, int];
v = [v, combv, intv];

indx = find(strcmp(p, 'replace'));

p{indx} = getString(message('signal:dfilt:info:InterpolationFactor'));
v{indx} = sprintf('%d', this.InterpolationFactor);

% [EOF]
