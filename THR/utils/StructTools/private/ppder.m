function PPD = ppder(PP)

%Parameters nagaan ...
if (nargin ~= 1), error('Wrong number of input arguments.'); end
if ~ispp(PP), error('PP-struct should be given as input argument.'); end

[Brk, Co, NPieces, Order, NDim] = unmkpp(PP);

ScaleFct = Order-1:-1:1;
DCo = ScaleFct(ones(NPieces, 1), :) .*Co(:, 1:Order-1);

PPD = mkpp(Brk, DCo);