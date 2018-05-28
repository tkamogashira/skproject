function expression = parseExpression(expression, structName)
% PARSEEXPRESSION Replace parts of expression by leafs of a struct.
% 
% expression = parseExpression(expression, structName)
% 
% Arguments:
%  expression: a string that can be evaluated by Matlab; parts surrounded
%              by dolllar signs will be replaced by respective leafs of
%              structName.
%  structName: name of the structure who's leaves should be used when
%              parsing.
% 
% Example:
%  >> S.testleaf = 17;
%  >> expression = parseExpression('13 + $testleaf$', 'S')
%  expression =
%  13 + [S.testleaf]
%  >> eval(expression)
%  ans =
%      30


%% ---------------- CHANGELOG -----------------------
%  Thu Feb 3 2011  Abel   
%   removed surrounding [] in output 

dollarPos = strfind(expression, '$');
if ~isequal( 0, mod( length(dollarPos), 2 ) )
    error('Could not parse expression: expression shouldn''t contain odd amount of dollar signs.');
end
while dollarPos
    % replace each first dollarsign by '[structName.' and each second
    % dollarsign by ']'.
%     expression = [expression( 1:(dollarPos(1)-1) ) '[' structName '.' expression( (dollarPos(1)+1):(dollarPos(2)-1) ) ']' expression( (dollarPos(2)+1):end )];
	expression = [expression( 1:(dollarPos(1)-1) ) structName '.' expression( (dollarPos(1)+1):(dollarPos(2)-1) ) expression( (dollarPos(2)+1):end )];
	dollarPos = strfind(expression, '$');
end