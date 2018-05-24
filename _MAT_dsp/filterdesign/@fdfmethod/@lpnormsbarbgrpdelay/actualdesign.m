function varargout = actualdesign(this,hspecs,varargin)
%ACTUALDESIGN Perform the actual design.

%   Copyright 2010 The MathWorks, Inc.

args = designargs(this, hspecs);
args = [args,{this.MaxPoleRadius, ...           % Radius
        [this.InitNorm this.Norm], ...          % Norm
        this.DensityFactor, ...                 % Density
        }];    
      
args = parseic(this,args,args{1});
      
% Call iirgrpdelay
[~,~,tau,sos] = iirgrpdelay(args{:},varargin{:});
g = 1;
hspecs.NomGrpDelay = tau;

varargout = {{sos, g}, tau};

% [EOF]
