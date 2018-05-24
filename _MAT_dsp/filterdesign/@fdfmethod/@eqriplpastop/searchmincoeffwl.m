function Hbest = searchmincoeffwl(this,args,varargin)
%SEARCHMINCOEFFWL Search for min. coeff wordlength.
%   This should be a private method.
%
%   If args doesn't have wl field: search for global minimum.
%
%   If args has wl field: search for a filter with coeff wordlength of at
%                         most wl.

%   Copyright 2009 The MathWorks, Inc.

minordspec  = 'Fp,Fst,Ap,Ast';

designargs = {'equiripple',...                
                'MinPhase',this.MinPhase,...
                'StopbandShape',this.StopbandShape,...
                'StopbandDecay',this.StopbandDecay};
           
Hbest = searchmincoeffwlword(this,args,minordspec,designargs,varargin{:});
