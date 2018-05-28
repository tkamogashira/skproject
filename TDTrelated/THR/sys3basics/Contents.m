% SYS3BASICS
%
% Basic utilities for TDT sys3 control.
%                                           
%   Setup and Initialization.
%     sys3deviceList  - specify and retrieve list of sys3 devices connected.
%     sys3defaultdev  - default sys3 device.
%     sys3connection  - get/set type of TDT connection
%     Sys3setup       - list setup properties for local TDT setup.
%     Sys3reset       - reinitialize sys3 hardware.
%     sys3hardwarereset - hardware reset of all connected TDT system3 equipment
%     sys3status      - get status of sys3 device.
%     Sys3isactive    - true when TDT equipment has been initialized
%        
%   RPvdS Circuits.
%     RPvdSpath       - get/set path for RPvdS circuits
%     sys3loadCircuit - load COF circuit to sys3 device.
%     sys3run         - start RPX processing chain.
%     sys3halt        - halt RPX processing chain.
%     sys3trig        - send software trigger to RPX device.
%     sys3waitfor     - wait for rco-component to reach a certain criterium.  
%     sys3CircuitInfo - info on loaded circuit
%     sys3Fsam        - get sample frequency [kHz] from TDT device
%
%  Data exchange.
%     sys3setPar        - set parameter of RPx component.
%     sys3getpar        - get parameter value of RPx component.
%     sys3read          - read data from circuit buffer.
%     sys3write         - write data to RPx buffer or zero out buffer.
%     sys3ParTag        - list parameter tags of a circuit and their properties     
%     sys3doubleBufRead - read data from circuit bufferusing double-buffering
%
%  Debug tools and test functions.
%     TDTsampleRate     - exact sample rate [kHz] of TDT device
%     RP2sampleRate     - exact sample rate [kHz] of RP2.
%     RX6sampleRate     - exact sample rate [kHz] of RX6.
%     sys3tonetest      - test sys3 DAC by playing a tone
%     sys3bitOutTest    - test bit out channels.
%     sys3memorytest    - memorytest for databuffers
%     sys3editcircuit   - edit COF circuit in RPvdS
%  
%  Other.
%     sys3PA5           - set attenuator values of PA5s.
%     sys3PA5get        - get attenuator values of PA5s.
%     TDThelp           - launch TDThelp application.
%     sys3help          - help on various TDT oddities.
%     sys3dev           - activeX controls of TDT devices.
%     TDT2EARLY         - how to do TDT things using the EARLY toolbox
%     sys3UnloadedError - error message for unloaded device
%  
%  See also sys3help, seqplay, TDT2EARLY.
