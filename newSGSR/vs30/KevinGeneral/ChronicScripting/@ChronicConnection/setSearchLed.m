function chronicConnecton = setSearchLed(chronicConnection, ledNr, newState)

if chronicConnection.connected
    if ~ischar(newState)
        if newState
            newState = 'on';
        else
            newState = 'off';
        end
    end

    chronicConnecton = sendMessage(chronicConnection, ['searchled' newState num2str(ledNr) ]);
else
    error('You need to be connected to the Java software to use this function.')
end