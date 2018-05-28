% This circuit and program generates FIR filtered noise

RP = Circuit_Loader('C:\TDT\ActiveX\ActXExamples\RP_files\FIR_Filtered_Noise.rcx'); % Loads a circuit

if (invoke(RP,'GetStatus'))==7 % Checks to see that the circuit was loaded correctly
    
    for j = 1:1
    % Cycles through the three FIR filters.
    for i = 1:3

        % Loads one set of filter coefficients to an FIR.
        invoke(RP, 'SendParTable', 'FIRfilts', i); 

        pause(1);

    end
    end
    % Stop playing
    invoke(RP, 'Halt');
    
end
