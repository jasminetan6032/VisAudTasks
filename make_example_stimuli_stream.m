list_sounds = {'chewingL','clongL','harm-dev-L-50ms', 'harm-dev-R-50ms', '1500-Hz-std-L-50ms','800-Hz-std-R-50ms'};
cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/stereostimuli

for sound_i = 1:length(list_sounds)

    [sound, Fs] = audioread([list_sounds{sound_i} '.wav']);
    
    %save sound
    sounds{sound_i,1} = list_sounds{sound_i};
    sounds{sound_i,2} = Fs; %It's the same for the R sound too.
    sounds{sound_i,3} = sound;

end

Fs = sounds{1,2};

%number corresponds to order in list
right_ear = [6,6,6,6,6,6,6,4,6,6,6,6,4,6,6,6,6,6,6,4];

soundstream = sounds{right_ear(1),3};

for stimuli = 2:length(right_ear)
    length_of_pause = round(Fs * (.99+.3*rand(1))); 
    pause = zeros(length_of_pause,2);
    soundstream = vertcat(soundstream,pause,sounds{right_ear(stimuli),3});
end

audiowrite("right_ear.wav",soundstream,Fs)

clear soundstream

left_ear = [5,5,5,2,5,5,5,1];

soundstream = sounds{left_ear(1),3};

for stimuli = 2:length(left_ear)
    length_of_pause = round(Fs * (.99+.3*rand(1))); 
    pause = zeros(length_of_pause,2);
    soundstream = vertcat(soundstream,pause,sounds{left_ear(stimuli),3});
end

audiowrite("left_ear.wav",soundstream,Fs)
