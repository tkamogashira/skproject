function initfdaf(h,L,Step,Leakage,varargin)
%INITLMS Initialize LMS-based objects.
%
%   Inputs:
%       L          - adaptive filter length (integer > 0)
%       Step       - FDAF Step size (scalar,
%                    0 to 1; 1 = fastest convergence)
%       Leakage    - FDAF Leakage parameter (scalar, 0 to 1; 1 = no Leakage)
%       delta      - initial common value of all of the FFT input signal
%                    powers (scalar > 0)
%       AvgFactor  - averaging factor for the FFT powers (scalar, 0 to 1)
%       varargin   - changes depending on algorithm


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.
if nargin > 1, set(h,'FilterLength',L); end

if nargin > 2, set(h,'StepSize',Step); end

if nargin > 3, set(h,'Leakage',Leakage); end

% Call initializer
L = h.FilterLength;
initialize(h,L,varargin{:});
