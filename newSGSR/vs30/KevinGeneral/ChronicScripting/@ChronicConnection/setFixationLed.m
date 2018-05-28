function chronicConnecton = setFixationLed(chronicConnection, ledNr, newState)

if chronicConnection.connected
    if ~isequal(3, nargin)
        error('This function expects 2 arguments');
    end

    if ~ischar(newState)
        if newState
            newState = 'on';
        else
            newState = 'off';
        end
    end

    if ischar(ledNr)
        ledNr = translateDirection(ledNr);
    end

    chronicConnecton = sendMessage(chronicConnection, ['fixationled' newState num2str(ledNr) ]);
else
    error('You need to be connected to the Java software to use this function.')
end