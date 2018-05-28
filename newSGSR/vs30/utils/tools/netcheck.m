function netstat = netcheck(sURL)
% netcheck - check if website is available
%   Check wether a specified web server is available.
%   If no argument is given, 'http://www.kuleuven.be' is used.
%
%   sURL should be a valid URL, including protocol. 
%   Strings like 'www.kuleuven.be' will produce an error.
%
%   If the network is down, or the network cable is unplugged,
%   the function will return after 45 seconds (!). Haven't
%   figured out yet how to shorten the timeout.
%   
%   Return value:
%   0 : error occured
%   1 : everything ok
%
%   See also NTPsync.

if nargin < 1
   sURL = 'http://www.kuleuven.be';
end

import java.io.* java.net.*

%Retrieving page ...
netstat = 0; % pessimistic default ..
try,
   URLobj = URL(sURL);
   BufObj = BufferedReader(InputStreamReader(URLobj.openStream));
   netstat = 1;
catch
   % warning(['Error occured connecting to ' sURL])
   return;
end

clear URLobj;
clear BufObj;



