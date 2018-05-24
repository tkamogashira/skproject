function initap(h,L,Step,po,varargin)
%INITAP Initialize affine projection algorithms.
%
%   Inputs:
%       L        - filter length
%       Step     - affine projection Step size
%       po       - projection order
%       varargin - changes depending on algorithm


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

if nargin > 1, set(h,'FilterLength',L); end

if nargin > 2, set(h,'StepSize',Step); end

if nargin > 3, set(h,'ProjectionOrder',po); end

% Call initializer
initialize(h,varargin{:});
