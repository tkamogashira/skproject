function updatespinners(this)
%UPDATESPINNERS   Update the SpinnerModels

%   Author(s): J. Schickler
%   Copyright 1999-2005 The MathWorks, Inc.

if isempty(this.JavaHandles), return; end

import javax.swing.*;
import java.lang.*;

h = get(this, 'JavaHandles');

switch lower(this.Type)
    case 'interpolator'
        hm = SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(1));
        awtinvoke(hm, 'setMinimum', Integer(1));
        awtinvoke(hm, 'setMaximum', Integer(1));
        awtinvoke(h.decimation, 'setModel', hm);
        awtinvoke(h.decimation, 'setEnabled', false);

        hm = javax.swing.SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(this.InterpolationFactor));
        awtinvoke(hm, 'setMinimum', Integer(2));
        awtinvoke(h.interpolation, 'setModel', hm);
        awtinvoke(h.interpolation, 'setEnabled', true);

    case 'decimator'
        hm = javax.swing.SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(1));
        awtinvoke(hm, 'setMinimum', Integer(1));
        awtinvoke(hm, 'setMaximum', Integer(1));
        awtinvoke(h.interpolation, 'setModel', hm);
        awtinvoke(h.interpolation, 'setEnabled', false);
        
        hm = javax.swing.SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(this.DecimationFactor));
        awtinvoke(hm, 'setMinimum', Integer(2));
        awtinvoke(h.decimation, 'setModel', hm);
        awtinvoke(h.decimation, 'setEnabled', true);
        
    case 'fractional-rate converter'
        hm = javax.swing.SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(this.srcInterpolationFactor));
        awtinvoke(hm, 'setMinimum', Integer(2));
        awtinvoke(h.interpolation, 'setModel', hm);
        awtinvoke(h.interpolation, 'setEnabled', true);
        
        hm = javax.swing.SpinnerNumberModel;
        awtinvoke(hm, 'setValue', Integer(this.srcDecimationFactor));
        awtinvoke(hm, 'setMinimum', Integer(2));
        awtinvoke(h.decimation, 'setModel', hm);
        awtinvoke(h.decimation, 'setEnabled', true);
end

% [EOF]
