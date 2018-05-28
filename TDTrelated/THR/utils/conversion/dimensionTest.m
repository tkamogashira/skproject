function [Mess, T] = dimensionTest(X, Dim, MessPrefix, flag);
% dimensionTest - test dimension of a variable or constant
%     [Mess, T] = dimensionTest(X, MDim, MessPrefix) tests if X meets the condition
%     specified Dim. 
%     Dim = M (single number) tests whether numel(X)<=M.
%     Dim = [Min Max] tests whether Min<=numel(X)<=Max.
%
%     Dim may also be a char string:
%       'column'      tests whether all dimensions except size(X,1) are equal to 1.
%       'row'         tests whether all dimensions except size(X,2) are equal to 1.
%       'singlevalue' tests whether size(X)==[1 1]
%       'empty'       equals isempty(X)
%       'nonempty'    equals ~isempty(X)
%       'erow'        empty or row
%
%     Char-values of Dim such as 'row' are case-insensitive and may be 
%     abbreviated, as long they are unique.
%
%     Multiple tests can be performed in a single call by passing a
%     cell array of Dim arguments, whose elements will be evaluated one by one.
%
%     Note that a single call to numericTest can perform a combined
%     dimensionTest and numericTest.
%
%     [Mess, T] = dimensionTest(X, MDim, MessPrefix, 'lenientassign') 
%     allows single-valued X when MDIM indicates a fixed size, i.e. 
%           MDIM == [N N] & N>0)
%     This serves situations like in the following Matlab assigment:
%           X(3:6) = 7
%     which is valid even though the sizes of LHS and RHS do not strictly match.
% 
%     See also numericTest, Parameter/isFixedSized.

if nargin<4, flag = ''; end

persistent Alltests;
if isempty(Alltests),
    Alltests = {'column', 'row', 'singlevalue', 'empty', 'nonempty' 'erow'};
end

[Mess, T] = deal('',1);
if iscell(Dim), % multicall. Handle by recursion
    for ii=1:length(Dim),
        [Mess, T] = dimensionTest(X, Dim{ii}, MessPrefix);
        if ~T, return; end
    end
elseif isnumeric(Dim),
    error(numericTest(Dim, 'nonnegint', 'Dim argument is '));
    if isequal([1 1], size(Dim)),
        Dim = [0 Dim];
    elseif isequal([1 2], size(Dim)),
        % dolce far niente
    else,
        error('Dim argument has invalid size.')
    end
    N = numel(X);
    if isequal('lenientassign', flag) & isequal(1,N) & isFixedDimSpec(Dim, 'nonempty'), % test passed - see help text
    else,
        if N>Dim(2),
            T = 0;
            Mess = 'has too many elements';
        elseif N<Dim(1),
            T = 0;
            Mess = 'has too few elements';
        end
    end
elseif ischar(Dim),
    % test if condition string is known & unique
    [Dim, errMess] = keywordMatch(Dim, Alltests, 'Dim string');
    error(errMess);
    switch Dim,
    case 'column',
        T = isequal(1, size(X,2));
        if ~T, Mess = 'is not a column vector'; end
    case 'row',
        T = isequal(1, size(X,1));
        if ~T, Mess = 'is not a row vector'; end
    case 'singlevalue',
        T = isequal([1 1], size(X));
        if ~T, Mess = 'is not a single-element value'; end
    case 'empty',
        T = isempty(X);
        if ~T, Mess = 'is not empty'; end
    case 'nonempty',
        T = ~isempty(X);
        if ~T, Mess = 'is empty'; end
    case 'erow',
        T = isempty(X) | isequal(1, size(X,1));
        if ~T, Mess = 'is not a row nor empty'; end
    end % switch/case
end


if ~isempty(Mess), Mess = [MessPrefix ' ' Mess '.']; end





