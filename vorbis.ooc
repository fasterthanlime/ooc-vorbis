use vorbis

// types

OggFile: cover from OggVorbis_File

VorbisInfo: cover from vorbis_info {
    channels: extern Int
    rate: extern Int
}

// functions

ov_open : extern func (FStream, OggFile*, Pointer, Int) -> Int
ov_info : extern func (OggFile*, Int) -> VorbisInfo*
ov_read : extern func (OggFile*, Pointer, Int, Int, Int, Int, Int*) -> Int
ov_clear: extern func (OggFile*)