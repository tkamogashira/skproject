%copyMatrix - A private function to copy the input matrix to output matrix
%             maintaining the dimension, datatype and complexity of the
%             destination variable.
%
%   Input arguments:
%       inputData       - Data to be copied. It must be a scalar or a
%                         matrix with the same number of elements as the
%                         outputPrototype.
%       outputProtype   - A prototype variable whose complexity and data
%                         type will be maintained in the output.
%
%   Output:
%       outputMatrix    - Output data matrix. It has same dimension,
%                         complexity and datatype as that of the
%                         outputPrototype.
%        
