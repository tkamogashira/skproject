function initialize_bap(h,Offset,Coefficients)
%INITIALIZE  Initialize properties to correct dimension.


%   Author(s): R. Losada
%   Copyright 1999-2002 The MathWorks, Inc.

L = get(h,'FilterLength'); 
po = get(h,'ProjectionOrder');

if nargin < 2,
    Offset = 1;
end
set(h,'OffsetCov',Offset*eye(po));

if nargin > 2,
    set(h,'Coefficients',Coefficients);
else,
    set(h,'Coefficients',zeros(1,L));
end



