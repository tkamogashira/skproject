function outputMatrix = copyMatrix(inputData, outputPrototype)
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

%#codegen

% Create a temporary matrix outputData where the dimension and the datatype
% of the outputPrototype is maintained. Here, the complexity might have
% been lost.
if isscalar(inputData) || (numel(inputData) == numel(outputPrototype))
    outputData = outputPrototype;
    outputData(:) = inputData;
else
    coder.internal.errorIf(true, 'dsp:system:copyMatrix:CannotCopyMatrix');
end 
    
% Copy outputData to outputMatix by maintaining the complexity.
if isreal(outputPrototype)
    outputMatrix = real(outputData);
elseif isreal(outputData)
    outputMatrix = complex(outputData);
else
    outputMatrix = outputData;
end