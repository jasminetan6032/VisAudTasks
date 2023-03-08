#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 22 15:41:49 2022

@author: jwt30
"""
# import matplotlib
# matplotlib.use('Agg')
import mne

import matplotlib.pyplot as plt
# the following import is required for matplotlib < 3.2:
from mpl_toolkits.mplot3d import Axes3D  # noqa

mne.gui.coregistration(subjects_dir=())

auditory_raw_file = '/autofs/cluster/transcend/MEG/AttenAud/106201/visit_20210614/106201_AttenAud_run02_raw.fif'
aud_raw = mne.io.read_raw_fif(auditory_raw_file)
aud_events = mne.find_events(aud_raw, stim_channel='STI101')

visual_raw_file = '/autofs/cluster/transcend/MEG/AttenVis/106201/visit_20210614/106201_AttenVis_run02_raw.fif'
vis_raw = mne.io.read_raw_fif(visual_raw_file)
vis_events = mne.find_events(vis_raw, stim_channel='STI101')
mne.viz.set_browser_backend('qt')
#vis_raw.plot()
import mne
raw_file = '/autofs/cluster/transcend/MEG/AttenAud/104001/104001_AttenAud_run01_raw.fif'
raw = mne.io.read_raw_fif(raw_file)
correct_date=raw.info['meas_date'].replace(day=11)
raw.set_meas_date(correct_date)
import matplotlib.pyplot as plt
# the following import is required for matplotlib < 3.2:
from mpl_toolkits.mplot3d import Axes3D  # noqa

fig = plt.figure()
ax2d = fig.add_subplot(121)
ax3d = fig.add_subplot(122, projection='3d')
aud_raw.plot_sensors(ch_type='eeg', axes=ax2d)
aud_raw.plot_sensors(ch_type='eeg', axes=ax3d, kind='3d')
ax3d.view_init(azim=70, elev=15)

visual_event_dict = {'search_4': 1,
                     'search_6': 2,
                     'search_8': 3,
                     'search_10': 4,
                     'pop-out_4': 5,
                     'pop-out_6': 6,
                     'pop-out_8': 7,
                     'pop-out_10': 8,
                     'target': 32,
                     'response_right': 2048,
                     'response_left': 32768
                     }
vis_raw.plot(events=vis_events, event_id=visual_event_dict)

auditory_event_dict = {'attend_right_standard_high_right': 1,
                     'attend_right_standard_low_right': 3,
                     'attend_right_target_high': 11,
                     'attend_right_target_low': 13,
                     'attend_right_low_left': 5,
                     'attend_right_high_left': 7,
                     'attend_right_devL_low': 35,
                     'attend_right_devL_high': 37,
                     'novel_left_low': 25,
                     'novel_left_high': 27,
                     'attend_left_standard_high_left': 2,
                     'attend_left_standard_low_left': 4,
                     'attend_left_target_high': 12,
                     'attend_left_target_low': 14,
                     'attend_left_low_right': 6,
                     'attend_left_high_right': 8,
                     'attend_left_devR_low': 36,
                     'attend_left_devR_high': 38,
                     'novel_right_low': 26,
                     'novel_right_high': 28,
                     'response_right': 2048,
                     'response_left': 32768
                     }

# exploring subjet 085701's head size
recent_raw_file = '/autofs/cluster/transcend/MEG/AttenVis/085701/visit_20220324/085701_AttenVis_run02_raw.fif'
recent_raw = mne.io.read_raw_fif(recent_raw_file)
montage_recent = mne.channels.read_dig_polhemus_isotrak(recent_raw_file,ch_names=None, unit='m')
montage_recent.get_positions()

old_raw_file = '/autofs/cluster/transcend/MEG/speech/085701/1/085701_speech_1_raw.fif'
old_raw = mne.io.read_raw_fif(old_raw_file)
montage_old = mne.channels.read_dig_fif(old_raw_file)
montage_old.get_positions()

import matplotlib.pyplot as plt
# the following import is required for matplotlib < 3.2:
from mpl_toolkits.mplot3d import Axes3D  # noqa

fig = plt.figure()
ax2d = fig.add_subplot(121)
ax3d = fig.add_subplot(122, projection='3d')
ax3d.view_init(azim=70, elev=15)
recent_raw.plot_sensors(ch_type='mag', axes=ax2d)
recent_raw.plot_sensors(ch_type='mag',axes=ax3d, kind='3d')


fig = mne.viz.plot_alignment(
    old_raw.info, dig=False, eeg=False,
    surfaces=[], meg=['helmet', 'sensors'],
    coord_frame='meg'
)
mne.viz.set_3d_view(fig, azimuth=50, elevation=90, distance=0.5)

ax3d = fig.add_subplot(122, projection='3d')
ax3d.view_init(azim=70, elev=15)
old_raw.plot_sensors(ch_type='mag', kind='3d')

raw_file = '/autofs/cluster/transcend/MEG/AttenAud/104001/104001_AttenAud_run02_raw.fif'
raw = mne.io.read_raw_fif(raw_file)

import mne

auditory_raw_file = '/autofs/cluster/transcend/MEG/AttenAud/AC005/visit_20220327/900005_AttenAud_run01_raw.fif'
aud_raw = mne.io.read_raw_fif(auditory_raw_file)
aud_events = mne.find_events(aud_raw, stim_channel='STI101')
event_list = aud_events[:,2]
events=event_list.tolist()
eoi = [i for i in events if i < 100] 
