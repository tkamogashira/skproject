function oldfh = midicallback(h, varargin)
    % MIDICALLBACK Call a function handle when MIDI controls change value.
    %   OLDFH = MIDICALLBACK(H,NEWFH) sets NEWFH as the function handle to be
    %   called when H changes value; return the previous function handle
    %   OLDFH.
    %
    %   OLDFH = MIDICALLBACK(H,[]) clears the function handle.
    %
    %   FH = MIDICALLBACK(H) returns the current function handle.
    %
    %   The callback function handle must take one input argument, the
    %   midicontrols object whose value changed, and produce no outputs:
    %       function callback(H)
    %
    %   The following example uses MIDICALLBACK with an anonymous
    %   function to interactively read MIDI controls.
    %
    %    >> h = midicontrols; 
    %    >> midicallback(h,@(h)disp(midiread(h)));
    %    >> % Now move any control on the default MIDI device.
    %        0.6587
    %        0.6429
    %        0.6349
    %        0.6270
    %        0.6190
    %        0.6111
    %        0.6032
    %        0.5952
    %    >> clear h
    %
    %   MIDISYNC is useful in synchronizing GUIs with MIDI controls, such
    %   that moving a MIDI control changes a GUI control, and changing the
    %   GUI control moves the MIDI control. For example, you can implement
    %   the MIDI --> GUI direction of the synchronization by adding the
    %   following line to a uicontrol callback:
    %
    %   % Example of sending a GUI slider change to MIDI control;
    %   % put this in the slider's callback.
    %   midisync(h, get(slider, 'Value'));
    %
    %
    %   See also MIDIID, MIDICONTROLS, MIDIREAD, and MIDISYNC.
    
    %   Copyright 2012-2013 The MathWorks, Inc.
    
    if nargout > 0
        oldfh = callback(h, varargin{:});
    else
        callback(h, varargin{:});
    end
end
