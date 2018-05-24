function [hspecsArbMag fmethodArbMag] = getarbmagdesignobjects(this,hspecs) 
%GETARBMAGDESIGNOBJECTS   

%   Copyright 2009 The MathWorks, Inc.

Fs = hspecs.ActualDesignFs;
F = this.Fspec*(Fs/2);

W = zeros(size(F));

idx = find(F>30 & F<200);
W(idx) = 10*ones(1,length(idx));

idx = find(F>15000);
W(idx) = fliplr(linspace(10,20,length(idx)));

W = W(F<=(Fs/2));

w = 10.^(W/20);

[hspecsArbMag fmethodArbMag] = geteqripdesignobjects(this,w);

% [EOF]