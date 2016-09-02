function setState(obj, command, state, x, y)
%SETSTATE Sets the state of an open gaze variable
%   If the variable is non-state, just enter the input the eyetracking
%   object and the variable name
%   If the variable is state-based, enter the eyetracking
%   object, the variable and the desired
%   state
%   If the variable has X and Y coords, enter the eyetracking
%   object, the command, a dummy state (anything you like) and an X and Y
%   postion.
    if nargin==3
        fprintf(obj.client_socket, ['<SET ID="',command,'" STATE="',state,'" />']);
    elseif nargin==2
        fprintf(obj.client_socket, ['<SET ID="',command,'" />']);
    elseif nargin==5
        fprintf(obj.client_socket, ['<SET ID="',command,'" X="',x,'" Y="', y,'"/>']);
    end
end

