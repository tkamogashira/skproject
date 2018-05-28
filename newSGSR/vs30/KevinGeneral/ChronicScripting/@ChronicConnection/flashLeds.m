function chronicConnecton = flashLeds(chronicConnection, time)

if ~isequal(2, nargin)
    error('This function expects two arguments');
end

if chronicConnection.connected
    if ~isnumeric(time) | ~isequal([1,1], size(time)) | ~isequal(0, mod(time, 1)) %#ok<OR2>
        error('The flash time shound be an integer numerical value');
    end
    
    chronicConnecton = sendMessage(chronicConnection, ['flashleds' num2str(time)]);
else
    error('You need to be connected to the Java software to use this function.')
end