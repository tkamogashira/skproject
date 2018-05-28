function PB = PropertyBag(varargin)
%PROPERTYBAG    constructor for property bag object.
%   PROPERTYBAG creates an empty property bag.
%
%   PROPERTYBAG(PB) simply returns the supplied property bag object. This
%   is the copy constructor.
%
%   Methods for a property bag object are:
%       Add      (ADD.M)      : add property or relation to property bag
%       Rm       (RM.M)       : remove property and its relation
%       Set      (SET.M)      : set the value of a specific property
%       Get      (GET.M)      : get value of specific property
%       IsEmpty  (ISEMPTY.M)  : check if property bag is empty
%       IsMember (ISMEMBER.M) : check if property is member of a bag
%       Union    (UNION.M)    : combine contents of property bags 
%       Disp     (DISP.M)     : display contents of a property bag
%
%   A wrapper for handle graphics object is also included (HDL2PB).

%B. Van de Sande 13-05-2004

if (nargin == 0),
    PB.Properties = struct('name', [], 'constraints', [], 'value', []);
    PB.Relations  = struct('name', [], 'function', []);
    PB.Properties(1) = []; PB.Relations(1) = [];
    PB = class(PB, 'PropertyBag');
elseif (nargin == 1) & isclass(varargin{1}, 'PropertyBag'),
    PB = varargin{1};
else, error('Syntax error'); end