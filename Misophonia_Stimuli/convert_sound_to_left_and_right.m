%create list of sounds to convert
list_misophones = {'chewing','nail_clipping','joint_cracking','snoring'};

cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/Misophonia_Stimuli

for sound_i = 1:length(list_misophones)

[sound, Fs] = audioread([list_misophones{sound_i} '.wav']);

%Play only to left ear
sound_L = sound;
sound_L(:,2) = 0;
filename = [list_misophones{sound_i} 'L.wav'];

audiowrite(filename,sound_L,Fs)

%Play only to right ear
sound_R = sound;
sound_R(:,2) = sound_R;
sound_R(:,1) = 0;
filename = [list_misophones{sound_i} 'R.wav'];

audiowrite(filename,sound_R,Fs)

%empty previous variables
sound = [];
sound_L = [];
sound_R = [];
Fs = [];
filename = [];

end