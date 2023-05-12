list_misophones = {'breathing','chewing','joint_cracking','lip_smacking','nail_clipping','slurping','snoring', 'sniffing', 'swallowing','throat_clearing'};

cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/Misophonia_Stimuli

for sound_i = 1:length(list_misophones)
    [sound, Fs] = audioread([list_misophones{sound_i} '.wav']);
    checkdims{sound_i,1} = size(sound);
    sound_norm = normalize(sound,'range',[-1 1]);
    filename = [list_misophones{sound_i} '.wav'];
    audiowrite(filename,sound_norm,Fs)
end
