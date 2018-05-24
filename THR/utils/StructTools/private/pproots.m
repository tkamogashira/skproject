function  Rts = pproots(PP)

%Parameters nagaan ...
if (nargin ~= 1), error('Wrong number of input arguments.'); end
if ~ispp(PP), error('PP-struct should be given as input arguments.'); end

[Brk, Co, NPieces, Order, NDim] = unmkpp(PP);

Rts = [];
for PieceNr = 1:NPieces
    r = roots(Co(PieceNr, :)); r = r + Brk(PieceNr);
    r = r(find((r >= Brk(PieceNr)) & (r <= Brk(PieceNr+1) & isreal(r))));
    Rts = [Rts r'];
end    
