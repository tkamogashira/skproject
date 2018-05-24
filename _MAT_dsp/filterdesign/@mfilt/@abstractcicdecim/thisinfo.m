function [p, v] = thisinfo(this)
%THISINFO   Get the information about this object.

%   Author(s): J. Schickler
%   Copyright 1999-2004 The MathWorks, Inc.

[p,int,comb,v,intv,combv] = cic_info(this);
p = [p, int, comb];
v = [v, intv, combv];

indx = find(strcmp(p, 'replace'));

p{indx} = getString(message('signal:dfilt:info:DecimationFactor'));
v{indx} = sprintf('%d', this.DecimationFactor);

% [EOF]
