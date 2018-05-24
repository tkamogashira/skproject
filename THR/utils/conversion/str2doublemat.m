function X = str2doublemat(S, Evaluatable)
% str2doublemat - convert string to double precision matrix.
%    str2doublemat is the matrix version of str2double.
% 
%    str2doublemat(S) converts the string S to MATLAB's double representation
%    using sufficient precision (17 digits) to make the conversion invertible.
%    S may only contain ASCII representations of complex numbers, each evaluable
%    by double2str, and delimeters '['  ']'  ';' ' '. 
%    In other words, S is a potential output of mat2str.
%    Any individual substring between these delimiters that does not 
%    convert is represented by a NaN. Since str2double is used for the
%    individual elements, no side effects or interpretation occurs.
%
%    In case of unparsable S, like '[4; 5 7]' or '[[[9' the char string 'Unparsable'
%    is returned instead of the numeric matrix on successful exit.
%
%    str2doublemat(S, C) , where C is a cellstring, evaluates any occurence
%    of the words in S in C. Composite expressions are not parsed - only single 
%    words, which are passed to eval. For example, str2doublemat('pi',
%    {'pi'}} yields pi.
% 
%    EXAMPLE
%      str2doublemat('[1 2 3; 4 5 6]')
%         ans =
%          1     3     5
%          2     4     6
%
%    See also mat2str.

if nargin<2, Evaluatable = {}; end
Deli = '[] ; ';

if ~isempty(strfind(S, '/')), % must intercept that here, or it will interfere with replacements below
    X = 'Unparsable';
    return;
end

% ===replace evaluatable occurences====
T = S; % need tmp copy

% find the expressions in between the delimiters
for ii=1:length(Deli), T = strrep(T,Deli(ii),'/'); end % replace all delimters by '/' 
W = words2cell(T,'/'); % words in cellstr (note: double delimeters count as one, so no ''s in W)
imatch = find(ismember(W, Evaluatable));
ToBeEvaluated = W(imatch);

for ii=1:length(ToBeEvaluated),
    cand = ToBeEvaluated{ii};
    value = eval(cand, 'nan'); % not evaluable -> nan
    replacement = mat2str(value,17); % 17: invertible precision
    S = strrep(S,cand,replacement);
end

% ===find out the size of the matrix espressed in S====
% the trick is to replace each word in S by the simple number string '0'

T = S; % need tmp copy again
% the follwoing has been done before, but we need it again because of the above replacements
for ii=1:length(Deli), T = strrep(T,Deli(ii),'/'); end % replace all delimters by '/' 
W = words2cell(T,'/'); % words in cellstr (note: double delimeters count as one, so no ''s in W)
T = S; % again
for ii=1:length(W), 
    word = W{ii};
    T = strrep(T,word,'0');
end

X = eval(T, '''Unparsable''');
if ischar(X), return; end
Sz = size(X);

% ===convert the individual elements

% the values are represented by the words in W
X = zeros(size(W));
for ii=1:length(W),
    X(ii) = str2double(W{ii}); % usage of str2double prevents evaluations & side effects
end

if ~isequal(length(W), prod(Sz)),
    X = 'How the hell?!';
    return
end

% ===reshape
X = reshape(X, Sz);
    
    
    
