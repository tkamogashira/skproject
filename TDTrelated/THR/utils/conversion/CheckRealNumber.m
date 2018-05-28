function mess = CheckRealNumber(x, Bounds, MaxSize);
% CheckRealNumber - checks if the arg is a real number of correct size and value
% SYNTAX:
% mess = CheckRealNumber(x, Bounds, MaxSize);
% where x is the value to be tested;
%     Bounds = [lowerBound, higherBound] 
%             (single value-> [0 Bounds]; not specified/empty: no bound checking)
%     MaxSize = [maxNcol maxNrow] (single value -> max number of elements; default:1)
%               empty MaxSize -> no size checking
% CheckRealNumber first checks if x is numeric, then if it is real. Next, the
% bounds and size are checked.
% a string mess is  returned indicating what's wrong with x (empty if OK)
%  
% Special cases: 3-element Bounds: x must be integer if Bounds(3).
%                Bounds == nan: Bounds=[-inf inf 1] (no bound checking, x must be integer)

if nargin<2, Bounds = []; end;
if nargin<3, MaxSize = 1; end;
mustBeInt = 0;

if length(Bounds)>2,
   mustBeInt = Bounds(3);
   Bounds = Bounds(1:2);
   Bounds = Bounds(find(~isnan(Bounds)));
elseif isnan(Bounds),
   mustBeInt = 1;
   Bounds = [];
end
   

mess = '';

if ~isnumeric(x),
   mess = 'non-numeric value';
   return;
end

if any(~isreal(x)),
   mess = 'non-real value';
   return;
end

if any(isnan(x)),
   mess = 'not a number';
   return;
end

if mustBeInt,
   if any(rem(x,1)),
      mess = 'not an integer value';
      return;
   end
end

if ~isempty(Bounds),
   if length(Bounds)==1, Bounds = [0, Bounds]; end;
   if any(x<Bounds(1)),
      mess = 'too small';
   end
   if any(x>Bounds(2)),
      mess = 'too large';
   end
end

if ~isempty(MaxSize),
   if prod(size(MaxSize))==1,
      NN = prod(size(x));
      if NN>MaxSize,
         mess = 'too many values';
         return;
      end
   elseif ndims(x)>length(MaxSize),
      mess = 'too many dimensions';
      return;
   elseif isequal([1 2],size(MaxSize)), % check rows/columns
      if any(size(x,1)>MaxSize(1)),
         mess = 'too many rows';
         return;
      elseif any(size(x,2)>MaxSize(2)),
         mess = 'too many columns';
         return;
      end
   else % compare dimension-wise
      if any(size(x)>MaxSize),
         mess = 'too many columns and/or rows';
         return;
      end
   end
end

