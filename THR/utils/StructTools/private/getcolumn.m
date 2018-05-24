function C = GetColumn(M, ColNr)
%GETCOLUMN    STRUCTTOOLS utility.
%   If a field has numeric rowvectors as elements instead of scalars, the
%   special command GETCOLUMN can be used to extract a single element from
%   these vectors to form a numerical vector. This command has the following
%   syntax:              GETCOLUMN($FieldName$, Nr)
%   and returns a numerical column assembled from the requested element number
%   out of each rowvector of the specified fieldname.
%
%   Additional tools that can be used for expressions are FINDPATTERN and
%   FINDELEMENT.

%B. Van de Sande 27-10-2004

if (nargin ~= 2) | ~isnumeric(M) | ~isnumeric(ColNr) | (length(ColNr) ~= 1), error('Wrong syntax for GETCOLUMN.'); end
if (ColNr < 1) | (ColNr > size(M, 2)), error('Requested column number doesn''t exist.');
else, C = M(:, ColNr); end