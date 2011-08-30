use vorbis

// types

OggFile: cover from OggVorbis_File

VorbisInfo: cover from vorbis_info {
    channels: extern Int
    rate: extern Int
}

OggInt64: cover from ogg_int64_t

OggCallbacks: cover from ov_callbacks {
    read_func : Func (ptr: Pointer, size: SizeT, nmemb: SizeT, datasource: Pointer) -> SizeT
    seek_func : Func (datasource: Pointer, offset: OggInt64, whence: Int) -> Int
    close_func: Func (datasource: Pointer) -> Int
    tell_func : Func (datasource: Pointer) -> Long
}

// functions

ov_open : extern func (f: FStream, vf: OggFile*, initial: Pointer, ibytes: Long) -> Int
ov_open_callbacks: extern func (datasource: Pointer, vf: OggFile*, initial: Pointer, ibytes: Long, callbacks: OggCallbacks) -> Int

ov_info : extern func (vf: OggFile*, link: Int) -> VorbisInfo*
ov_read : extern func (vf: OggFile*, buffer: Pointer, length: Int, bigendianp: Int, word: Int, sgned: Int, bitstream: Int*) -> Int
ov_clear: extern func (vf: OggFile*)
