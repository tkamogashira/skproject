function midisync(h, varargin)
    % MIDISYNC Send values to MIDI controls to synchronize them.
    %   MIDISYNC(H) sends the initial values specified to MIDICONTROLS when
    %   H was created to the MIDI controls associated with MIDICONTROLS
    %   object H.
    %
    %   MIDISYNC(H,VALUES) sends VALUES to the MIDI controls associated
    %   with MIDICONTROLS object H.  VALUES must follow the same rules as
    %   InitialValue arguments to MIDICONTROLS (see MIDICONTROLS).
    % 
    %   MIDISYNC is useful with bi-directional MIDI devices, which can
    %   both send and receive messages, and move a control in response to a
    %   received message.  For example, when a midicontrols object is
    %   first created, it is often helpful to move the MIDI control to
    %   match the initial value of the object.
    %   
    %   % Create a midicontrols object for MIDI control 1081,
    %   % with an initial value of 0.5.
    %   h=midicontrols(1081,0.5);
    %   % Move control 1081 to its midpoint (0.5) to synchronize with h.
    %   midisync(h);
    %
    %   MIDISYNC is also useful in synchronizing GUIs with MIDI controls,
    %   such that moving a MIDI control changes a GUI control, and changing
    %   the GUI control moves the MIDI control. For example, you can
    %   implement the GUI --> MIDI direction of the synchronization by
    %   adding the following line to a uicontrol callback:
    %
    %   % Example of sending a GUI slider change to MIDI control;
    %   % put this in the slider's callback.
    %   midisync(h, get(slider, 'Value'));
    %
    %   See UICONTROL for more information about creating user interface
    %   controls; see MIDICALLBACK for a way to implement the MIDI --> GUI
    %   direction of synchronization.
    %
    %   Many MIDI devices are not bi-directional; calling MIDISYNC with a
    %   uni-directional device has no effect.  MIDISYNC cannot tell whether
    %   a value was successfully sent to a device, or even whether the
    %   device is bi-directional.  Therefore no errors or warnings are
    %   thrown if sending a value fails.
    %
    %   MIDISYNC will only send values if the midicontrols object is
    %   associated with specific control.  For example:
    %
    %   h = midicontrols;
    %   midisync(h);        % does nothing
    %
    %   See also MIDIID, MIDICONTROLS, MIDIREAD, and MIDICALLBACK.

    %   Copyright 2013 The MathWorks, Inc.
    
    sync(h, varargin{:});
end
