function boolean = FindElement(Col, Elem)
%FINDELEMENT    STRUCTTOOLS utility.
%   If a field has numeric vectors of different sizes as elements, the special
%   command FINDELEMENT can be used. This command has the following syntax:
%                        FINDELEMENT($FieldName$, Element)
%   and checks if the numerical value given by Element is present in the different 
%   elements of the field given by the name FieldName. I.e. it checks for the
%   presence of an element in a set.
%
%   Additional tools that can be used for expressions are GETCOLUMN and FINDPATTERN.

%B. Van de Sande 21-02-2005

%Column should always be a cell-array ...
if (nargin ~= 2), error('Wrong syntax for FINDELEMENT.'); end
if ~iscell(Col), Col = num2cell(Col, 2); end
if ~all(cellfun('isclass', Col, 'double')) | ~isnumeric(Elem) | (length(Elem) ~= 1), 
    error('Wrong syntax for FINDELEMENT.'); 
end 

NElem = length(Col); boolean = logical(zeros(NElem, 1));
for n = 1:NElem, boolean(n) = ismember(Elem, Col{n}); end
