### decode

The decode sample opens the plop.ogg file and writes it to plop.raw.

The file it outputs is raw audio data, with 1 channels, 44.1KHz, 16-bit, little endian.

To play it back using mplayer, you can use the following:

> mplayer -demuxer rawaudio -rawaudio channels=1:rate=44100:samplesize=2 plop.raw

You can also convert it to wav using sox:

> sox -r 44100 -e signed -b 16 -c 1 plop.raw plop.wav

### Licensing

The sound effect 'plop.ogg' has been registered by Amos Wenger and is hereby released
under a Creative Commons CC-BY-SA 2.0 license.

