cd /local_mount/space/hypatia/2/users/Jasmine/github/VisAudTasks/

[devL, fsdevL] = audioread('./stereostimuli/harm-dev-L-50ms.wav');
[devR, fsdevR] = audioread('./stereostimuli/harm-dev-R-50ms.wav');


[stdL1500, fsstdL1500] = audioread('./stereostimuli/1500-Hz-std-L-50ms.wav');
[stdR1500, fsstdR1500] = audioread('./stereostimuli/1500-Hz-std-R-50ms.wav');

[stdL800, fsstdL800] = audioread('./stereostimuli/800-Hz-std-L-50ms.wav');
[stdR800, fsstdR800] = audioread('./stereostimuli/800-Hz-std-R-50ms.wav');

[nL1, fsnL1] = audioread('./stereostimuli/bangL.wav');
[nL2, fsnL2] = audioread('./stereostimuli/barkL.wav');
[nL3, fsnL3] = audioread('./stereostimuli/chainL.wav');
[nL4, fsnL4] = audioread('./stereostimuli/clingL.wav');
[nL5, fsnL5] = audioread('./stereostimuli/clongL.wav');
[nL6, fsnL6] = audioread('./stereostimuli/dtmfL.wav');
[nL7, fsnL7] = audioread('./stereostimuli/honkL.wav');
[nL8, fsnL8] = audioread('./stereostimuli/raygunL.wav');


[nR1, fsnR1] = audioread('./stereostimuli/bangR.wav');
[nR2, fsnR2] = audioread('./stereostimuli/barkR.wav');
[nR3, fsnR3] = audioread('./stereostimuli/chainR.wav');
[nR4, fsnR4] = audioread('./stereostimuli/clingR.wav');
[nR5, fsnR5] = audioread('./stereostimuli/clongR.wav');
[nR6, fsnR6] = audioread('./stereostimuli/dtmfR.wav');
[nR7, fsnR7] = audioread('./stereostimuli/honkR.wav');
[nR8, fsnR8] = audioread('./stereostimuli/raygunR.wav');

sounds = [fsnL1,fsnL2,fsnL3,fsnL4,fsnL5,fsnL6,fsnL7,fsnL8];


    play_sound(nL1,fsnL1);

    PsychPortAudio('Close' [, pahandle]);

    function play_sound(sound_data, sfreq)
        s = inputname(1);
        %disp(['Stimulu is ''' s '''.'])
        pahandle = PsychPortAudio('Open');
        PsychPortAudio('Volume',pahandle,.75);
        InitializePsychSound;
        pahandle = PsychPortAudio('Open');
        PsychPortAudio('FillBuffer', pahandle, sound_data);
        PsychPortAudio('Start', pahandle, 1, 0, 1);
        PsychPortAudio('Stop',pahandle,1,1);
    end

