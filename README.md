# Opengaze-in-Matlab
<h3>About</h3>
<p>
A matlab-based package for communicating with gp3 eyetracker by gazepoint over the opengaze API
Based in part off of mperez4/gazepoint_toolkit, but with support for more recent matlab and gp3 client versions and some useful administration functions.
Stable and in use.</p>
<p>
KbWaitEyeTracking and waitForCalibration are designed to work with Psychtoolbox, and will only work if you have it installed.
</p>
<h3>Installation/Setup</h3>
<p>Download this repository, and unzip into your expeirment's project folder. Make sure the folder is added to the matlab path. Also, make sure that the gp3 client is running. This software is a free download from the gazepoint website once you've purchased a camera. Intructions should be included with the camera.</p>
<h3>Usage Patterns</h3>
<p>
There are two usage patterns. In the simpler case, you can use this library in conjunction with psychtoolbox. In this case, you can use the KbWaitEyetracking and waitForCalibration functions to perform common eyetracking tasks. A typical usage would look like the following:
<pre>
<code>
eyetracker = eyeTrackingAdmin('start');
eyetracker = waitForCalibration('calibrate',eyetracker);

%prep stimuli, ect

for trial_n = 1:n_trials:
	//draw stimuli, get everything setup
	[resp, rt, ~, gp] = KbWaitEyetrack([],[],eyetracker);
	gp = cleanGP(gp);
end
eyetracker = eyeTrackingAdmin('end');
</code>
</pre>

<p>
The more advanced usage pattern, which doesn't require psychtoolbox, would look like the following:</p>
<pre>
<code>
eyetracker = eyeTrackingAdmin('start');
eyetracker = eyeTrackingAdmin('calibrate',eyetracker);
for trial_n = 1:n_trials:
	setState(eyetracker, 'ENABLE_SEND_DATA', '1');
	setState(eyetracker, 'ENABLE_SEND_POG_FIX', '1');
gp = {};counter = 0;
	while 1:%Subject does stuff that you want on eye tracking
while (get(eyetracker.client_socket, 'BytesAvailable') > 0)
   counter = counter+1;
   gp{counter} = fscanf(eyetracker.client_socket);
end
end
	%subject finishes doing stuff
setState(eyetracker, 'ENABLE_SEND_POG_FIX', '0');
setState(eyetracker, 'ENABLE_SEND_DATA', '0');
eyetracker = eyeTrackingAdmin('end');
</code>
</pre>

<p>
This usage pattern is required if you want to redraw stimuli during the period where the subject is considering the stimuli (for example, to make the stimuli responsive to a subject's keypress)
</p>
