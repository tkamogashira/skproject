function idx = rotIdx( counter, amount )
% rotIdx - Return a rotating index
%
% idx = rotIdx( counter, amount )
%    Return an index, smaller or equal than "amount".
%    The index is rotated: when it reaches amount, the next index returned
%    will be 1.

if amount < 1 || ~isequal(0, rem(amount,1))
    error('Amount should be a strictly positive whole number');
else
    idx = rem(counter, amount);
    if isequal(0, idx)
        idx = amount;
    end
end
