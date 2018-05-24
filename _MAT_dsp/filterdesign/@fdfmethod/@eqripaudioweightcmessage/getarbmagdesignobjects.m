function [hspecsArbMag fmethodArbMag] = getarbmagdesignobjects(this,hspecs) 
%GETARBMAGDESIGNOBJECTS   

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
F = this.Fspec*(Fs/2);

W = zeros(size(F));

idx = find(F>50 & F<100);
W(idx) = 20*ones(1,length(idx));

idx = find(F>5000);
W(idx) = 30*ones(1,length(idx));    

W = W(F<=(Fs/2));

w = 10.^(W/20);

[hspecsArbMag fmethodArbMag] = geteqripdesignobjects(this,w);

% [EOF]