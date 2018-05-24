function X = sys3getpar(Tag, Dev);  
% sys3getpar - get parameter value of RPx component  
%     sys3getPar(Tag, Dev) returns a parameter on device Dev via tag  
%     named Tag. Dev defaults to sys3defaultDev.  
%  
%     Note: sys3getPar should NOT be used for reading RPx buffers; use 
%     sys3read to read from buffers.
%  
%     See also sys3setpar, sys3read, sys3partag, sys3defaultDev.  
  
if nargin<2, Dev = ''; end  

% check whether Tag points to a data buffer 
DataType = sys3partag(Dev, Tag, 'datatype');
if isequal('DataBuffer', DataType),
    error(['ParTag ''' Tag ''' points to a DataBuffer, not a parameter. ', ...
        'Use sys3read instead.' ]);
end

[actx, Dev] = sys3dev(Dev);
% getTagVal used to return useless singles; convert to double to make sure
X = double(invoke(actx, 'GetTagVal', Tag)); 
  
  
