function sys3setPar(X, Tag, Dev);  
% sys3setPar - set parameter of circuit component  
%     sys3setPar(X, Tag, Dev) accesses a parameter on device Dev via tag  
%     named Tag and sets its value to X. Dev defaults to sys3defaultDev.  
%     Note that the way X is stored depends on the data type of the entry
%     in the circuit to which Tag points. For instance, writing a floating
%     point number to an integer (dark green) entry results in truncating.
%  
%     NOTE: sys3setPar should not be used for filling RPx buffers; use 
%     sys3write for writing arrays to buffers.  
%  
%     See also sys3getPar, sys3write, sys3tagList, sys3defaultDev.  
  
if nargin<3, Dev = ''; end  


% check whether Tag points to a data buffer 
DataType = sys3partag(Dev, Tag, 'datatype');
if isequal('DataBuffer', DataType),
    error(['ParTag ''' Tag ''' points to a DataBuffer, not a parameter. ', ...
        'Use sys3write instead.' ]);
end

if ~isequal(1, numel(X)) || ~isnumeric(X),  
    error('Parameter value must be a scalar number.');  
end  
  
[actx, Dev] = sys3dev(Dev);
stat = invoke(actx, 'SetTagVal', Tag, X);  
if ~stat,  
    error(['Error while setting parameter on ' Dev]);  
end  
  
  
