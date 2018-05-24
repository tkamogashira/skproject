function LMSSystemIdentifier
%LMSSystemIdentifier System identification using LMS adaptive filter
%#codegen

    % System objects need to be declared as persistent for code generation.
    persistent hlms hfilt

    % The persistent System objects should be initialized only once for
    % MATLAB Coder. We achieve this by initializing them inside a check 'if
    % isempty(persistent variable)'. This condition will be false after the
    % first time and the System objects are created only once.
    if isempty(hlms)
        % Create LMS adaptive filter used for system identification. The
        % property values arguments must be passed as constructor arguments
        % since dot notation is not allowed for System objects in MATLAB
        % Coder. Also note that the property values must be constants.

        hlms = dsp.LMSFilter(11, 'StepSize', 0.01);

        % Create system to be identified which is an FIR filter.
        hfilt = dsp.FIRFilter('Numerator', fir1(10, .25));
    end

    for i=1:10                                  % Run 10 iterations
        x = randn(100,1);                       % Get next 100 input samples
        d = step(hfilt, x) + 0.01*randn(100,1); % Create desired signal
        [~,~,w] = step(hlms, x, d);             % Run filter to identify system
    end

    % Functions that do not support code generation must be declared extrinsic.
    coder.extrinsic('stem', 'hold', 'legend');

    stem(get(hfilt, 'Numerator')); % Plot original response
    hold;
    stem(w, 'Marker', '+');        % Plot identified response
    legend('Original filter taps', 'Estimated filter taps');
end