function [ results ] = safeRead(obj)
%SAFEREAD safely read from the camera if bytes are available
results = [];
counter = 1;
while (get(obj.client_socket, 'BytesAvailable') > 0)                               
    results(counter) = fscanf(obj.client_socket);
    pause(.01);
    counter = counter+1;
end
end

