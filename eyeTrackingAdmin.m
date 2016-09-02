function [ obj ] = eyeTrackingAdmin( mode, obj )
%EYETRACKINGADMIN This function is the main hub for any eyetracking setup,
%administration or tear down. A typical usage might look something like the
%following:
%eyetracker = eyeTrackingAdmin('start');
%eyetracker = eyeTrackingAdmin('calibrate',eyetracker);
%Have subject do something
%While subject is doing something:
%setState(obj, 'ENABLE_SEND_DATA', '1');
%setState(obj, 'ENABLE_SEND_POG_FIX', '1');
%After they finish:
%setState(obj, 'ENABLE_SEND_POG_FIX', '0');
%setState(obj, 'ENABLE_SEND_DATA', '0');
%gp = {};counter = 0;
%while (get(obj.client_socket, 'BytesAvailable') > 0)
%   counter = counter+1;
%   gp{counter} = fscanf(obj.client_socket);
%end
%Alternatively, If you have psychtoolbox installed, use KBWaitEyetrack to
%collect eyetracking data while waiting for subject response.

if strcmp(mode,'start')
    %This creates a session with the eye tracker, using the default settings
    obj = [];
    obj.ip_address='127.0.0.1';
    obj.port_number = 4242;
    try
        obj.client_socket = tcpip(obj.ip_address, obj.port_number);
        set(obj.client_socket, 'InputBufferSize', 4096);
        fopen(obj.client_socket);
        obj.client_socket.Terminator = 'CR/LF';
        gazepoint_info = strcat('Connected to:', obj.ip_address, ' on port:', num2str(obj.port_number), '\n');
        fprintf(gazepoint_info);
    catch err
        fprintf('Make sure GazepointControl is open on host machine.');
        rethrow(err);
    end
    
elseif strcmp(mode,'calibrate')
    %This performs the 9-point calibration, edit the points if you want
    %a shorter or longer pattern.
    setState(obj, 'CALIBRATE_CLEAR'); %remove old calibration pattern
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.1', '.1');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.5', '.1');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.9', '.1');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.9', '.5');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.5', '.5');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.1', '.5');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.1', '.9');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.5', '.9');
    setState(obj, 'CALIBRATE_ADDPOINT', '1', '.9', '.9');
    setState(obj, 'CALIBRATE_SHOW','1');
    setState(obj, 'CALIBRATE_START','1');
    pause(20); %make sure you edit this if you alter the number of points
    setState(obj, 'CALIBRATE_SHOW','0');
    setState(obj, 'CALIBRATE_SHOW','0');
    setState(obj, 'CALIBRATE_START','0')
    fprintf(obj.client_socket, '<GET ID="CALIBRATE_RESULT_SUMMARY" />');
    setState(obj, 'ENABLE_SEND_DATA','0')
    disp('done with calibration')
    while (get(obj.client_socket, 'BytesAvailable') > 0)
        results = fscanf(obj.client_socket);
        %fprintf(results);
        pause(.01);
    end
    pause(1);
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
    
elseif strcmp(mode,'end')
    %call this when you are done to close TCPIP socket to camera
    fprintf('Shutting down connection')
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
    fclose(obj.client_socket);
    delete(obj.client_socket);
    clear obj.client_socket
    
elseif strcmp(mode, 'test')
    %%check for packet loss, run this when testing new camera/computer
    %%setup
    fprintf('Testing initiated. First, checking for packet loss.\n')
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_COUNTER" STATE="1" />');
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_DATA" STATE="1" />');
    counter = 1;
    all_results = zeros(200,1);
    while (get(obj.client_socket, 'BytesAvailable') > 0) && counter < 201
        results = fscanf(obj.client_socket);
        if strcmp(results, '<REC />')
            pause(.01);
        else
            pause(.01);
            results = strsplit(results, '"');
            if size(results,2)>3
            else
                all_results(counter) = str2num(results{2});
                counter = counter+1;
            end
            if mod(counter,20)==0
                fprintf('%.f percent finished with packet test\n',round(counter/2))
            end
        end
    end
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_COUNTER" STATE="0" />');
    fprintf(obj.client_socket, '<SET ID="ENABLE_SEND_DATA" STATE="0" />');
    results = safeRead(obj);
    n_loss = sum(diff(results)==1);
    fprintf('Out of 200 packets, %.f lost\n', [n_loss])
end
end

