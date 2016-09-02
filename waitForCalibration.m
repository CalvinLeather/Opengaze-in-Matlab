function [obj, wPtr] = waitForCalibration(obj, wPtr)
%WAITFORCALIBRATION Psychtoolbox required, performs camera calibration with nice interface.
    while 1
        text = 'Please press the up arrow key to start the calibration';
        DrawFormattedText(wPtr, text, 400, 200, 0, 60);
        %flip
        Screen('Flip', wPtr);
        %wait for response
        RestrictKeysForKbCheck(KbName('up'));
        [secs, keyCode, ~] = KbWait([],2);
        
        Screen('CloseAll')
        obj = eyeTrackingAdmin('calibrate',obj);
        [wPtr, rect] = Screen('OpenWindow', 0, 100, []);
        text = 'If you are satisfied, press the right arrow, otherwise press the left arrow';
        DrawFormattedText(wPtr, text, 400, 200, 0, 60);  
        Screen('Flip', wPtr);
        RestrictKeysForKbCheck([KbName('right'), KbName('left')]);
        [secs, keyCode, ~] = KbWait([],2);
        if find(keyCode) == KbName('right') %or whatever the right key is
           break 
        end
    end



end
