fx_version 'cerulean'
game 'gta5'

name 'dps-trains-stock'
author 'Big Daddy (assets), stripped for DPS'
description 'Trains Overhauled - rolling stock and consists only. Pack C# scripts, ticket system and gta5.meta deliberately excluded; dps-transit owns scheduling.'
version '3.01'

this_is_a_map 'yes'

files {
    'data/trains.xml',
    'data/vehicles.meta',
    'data/handling.meta',
    'data/vehiclelayouts.meta',
    'data/bdtrain_sounds.dat54.rel',
    'audiodirectory/train_sounds.awc',
    'stream/*.ytyp',
}

data_file 'TRAINCONFIGS_FILE'      'data/trains.xml'
data_file 'VEHICLE_METADATA_FILE'  'data/vehicles.meta'
data_file 'HANDLING_FILE'          'data/handling.meta'
data_file 'VEHICLE_LAYOUTS_FILE'   'data/vehiclelayouts.meta'
data_file 'AUDIO_WAVEPACK'         'audiodirectory'
data_file 'AUDIO_SOUNDDATA'        'data/bdtrain_sounds.dat'
data_file 'DLC_ITYP_REQUEST'       'stream/*.ytyp'
