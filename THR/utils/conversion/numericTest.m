function [Mess, T] = numericTest(N, CondStr, MessPrefix, Dim);
% numericTest - test whether a numeric meets a given condition
%     [Mess, T] = numericTest(N, CondStr, MessPrefix) tests if N meets the condition
%     specified in char string CondStr.
%     For single tests, CondStr is one of the keywords (quotes omitted for now):
%
%         {numeric nonnan noninf real rreal imaginary positive negative ...
%                nonnegative nonpositive nonzero integer posint nonnegint scalar unique}
%
%     Note: rreal == real & noninf & nonnan.
%     These keywords are case-insensitive and may be abbreviated, as long they
%     are unique. Many of these tests imply other tests. For instance, all tests
%     imply testing for numericality, and 'positive' implies 'real'. For such 
%     staggered tests, failure of the most general test is reported.
%
%     By convention, empty values fail all tests except 'numeric'.
%
%     On exit, logical T indicates whether N passes the test. Mess is
%     empty in case of succes and contains an appropriate message in case
%     of failure. MessPrefix is prepended to the Message (see Examples below).
%
%     Multiple tests are performed by stringing single keywords together
%     while using a slash as delimiter, as in 'rreal/integer'.
%
%     [Mess, T] = numericTest(N, CondStr, Pfx, Dim) also test for the right dimension.
%     For this purpose, the Dim argument is passed to dimensionTest after 
%     numericTest's own tests have been completed successfully.
%     numericTest(N, CondStr, Pfx, []) is equivalent to numericTest(N, CondStr, Pfx).
%
%     Example:
%        X = -1;
%        error(NumericTest(X, 'positive', 'Input argument X is '))
%     results in in error with message:
%       "Input argument X is not positive."
%
%     See also dimensionTest.

if nargin<3, MessPrefix=''; end
if nargin<4, Dim = []; end

if isequal('', CondStr), 
    CondStr = 'anything';
end

persistent Alltests;
if isempty(Alltests),
    Alltests = {'anything', 'numeric', 'nonnan', 'noninf', 'real', 'rreal', 'imaginary', 'positive', 'negative', ...
            'nonnegative', 'nonpositive', 'nonzero', 'integer' 'posint' 'nonnegint' 'scalar' 'unique'};
end

% multiple conditions: use recursive call
CND = Words2cell(CondStr, '/');
Ncond = length(CND);
if Ncond>1,
    for ii=1:Ncond,
        [Mess, T] = numericTest(N, CND{ii}, MessPrefix);
        if ~T, break; end % one failure is enough
    end
    if T, [Mess, T] = numericTest(N, 'anything', MessPrefix, Dim); end; % Dim need to be tested only once
    Mess = strrep(Mess, 'is  has', 'has'); % fix incompatible messging of dimensiontest vs numerictest
    Mess = strrep(Mess, 'is  is', 'is'); % fix incompatible messging of dimensiontest vs numerictest
    return
end

%==============single condition from here===============

% test if condition string is known & unique
[CondStr, errMess] = keywordMatch(CondStr, Alltests, 'condition string');
error(errMess);

[Mess, T] = deal('', 0);

% recursiveness was elegant but slow ..
Tnumeric = isnumeric(N);
if Tnumeric,
    Tnonnan = all(~isnan(N));
    Tnoninf =  all(~isinf(N));
    Treal =  isreal(N);
    Timag = all(0==real(N));
    Tpos = all(N>0);
    %-
    Tneg = all(N<0);
    Tnonpos = all(N<=0);
    Tnonneg = all(N>=0);
    Tnonzero = all(N~=0);
    Tinteger = all(N==round(N));
    %
    Tscalar = isscalar(N);
    Tunique = isscalar(unique(N));
else,
    Tnonnan = 0;
    Tnoninf =  0;
    Treal =  0;
    Timag = 0;
    Tpos = 0;
    %-
    Tneg = 0;
    Tnonpos = 0;
    Tnonneg = 0;
    Tnonzero = 0;
    Tinteger = 0;
    %
    Tscalar = isscalar(N);
    Tunique = isscalar(unique(N));
end
alltests = [Tnumeric, Tnonnan, Tnoninf, Treal, Timag, Tpos, Tneg, Tnonpos, Tnonneg, Tnonzero, Tinteger, Tscalar, Tunique];
Complaint = {'not numeric'  'NaN'  'inf'  'not real'  'not imaginary'  'not positive' ...
        'not negative' 'positive' 'negative' 'zero' 'noninteger' 'not a scalar' 'not unique'};
[iTnumeric, iTnonnan, iTnoninf, iTreal, iTimag, iTpos, iTneg, iTnonpos, iTnonneg, iTnonzero, iTinteger, iScalar, iUnique] ...
    = deal(1,2,3,4,5,6,7,8,9,10,11,12,13);

switch CondStr,
case 'anything',
    sel = [];
case 'numeric',
    sel = [iTnumeric];
case 'nonnan',
    sel = [iTnumeric iTnonnan];
case 'noninf',
    sel = [iTnumeric iTnoninf];
case 'real',
    sel = [iTnumeric iTreal];
case 'rreal',
    sel = [iTnumeric iTreal iTnonnan iTnoninf];
case 'imaginary',
    sel = [iTnumeric iTimag];
case 'positive',
    sel = [iTnumeric iTreal iTpos];
case 'negative',
    sel = [iTnumeric  iTreal iTneg];
case 'nonnegative',
    sel = [iTnumeric  iTreal iTnonneg];
case 'nonpositive',
    sel = [iTnumeric  iTreal iTnonpos];
case 'nonzero',
    sel = [iTnumeric iTnonzero];
case 'integer',
    sel = [iTnumeric iTinteger];
case 'posint',
    sel = [iTnumeric iTreal iTpos iTinteger];
case 'nonnegint'
    sel = [iTnumeric iTreal iTnonneg iTinteger];
case 'scalar'
    sel = [iScalar];
case 'unique'
    sel = [iUnique];
end

cmpl = Complaint(sel);
ifail = find(~alltests(sel), 1);
T = isempty(ifail);
if ~T,
    Mess = [MessPrefix cmpl{ifail} '.'];
end
    

% special case: empty N (see help)
if isempty(N),
    if ~isequal('anything', CondStr) & ~isequal('numeric', CondStr), 
        [Mess, T] = deal([MessPrefix 'empty.'], 0);
    end
end

% non-empty Dim: delegate to dimensionTest
if T & ~isempty(Dim),
    [Mess, T] = dimensionTest(N, Dim, MessPrefix);
end













