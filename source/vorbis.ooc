use vorbis

// types

_OggFile: cover from OggVorbis_File

VorbisInfo: cover from vorbis_info {
  channels: extern Int
  rate: extern Int
}

OggResultCode: enum {
  EREAD: extern(OV_EREAD)
  ENOTVORBIS: extern(OV_ENOTVORBIS)
  EVERSION: extern(OV_EVERSION)
  EBADHEADER: extern(OV_EBADHEADER)
  EFAULT: extern(OV_EFAULT)
  HOLE: extern(OV_HOLE)
  EBADLINK: extern(OV_EBADLINK)
  EINVAL: extern(OV_EINVAL)

  toString: func -> String {
    match this {
      case EREAD => "A read from media returned an error."
      case ENOTVORBIS => "Bitstream does not contain any Vorbis data."
      case EVERSION => "Vorbis version mismatch."
      case EBADHEADER => "Invalid Vorbis bitstream header."
      case EFAULT => "Internal logic fault; indicates a bug or heap/stack corruption."
      case HOLE => "There was an interruption in the data (one of: garbage \n" +
        "between pages, loss of sync followed by recapture, or a corrupt page)"
      case EBADLINK => "An invalid stream section was supplied to libvorbisfile, " +
        " or the requested link is corrupt."
      case EINVAL => "The initial file headers couldn't be read or are corrupt, " +
        " or that the initial open call for vf failed."
      case => "Unknown error"
    }
  }
}

OggInt64: cover from ogg_int64_t

OggCallbacks: cover from ov_callbacks {
  read_func : Func (Pointer, SizeT, SizeT, Pointer) -> SizeT
  seek_func : Func (Pointer, OggInt64, Int) -> Int
  close_func: Func (Pointer) -> Int
  tell_func : Func (Pointer) -> Long
}

// functions

ov_open : extern func (f: FStream, vf: _OggFile*, initial: Pointer, ibytes: Long) -> OggResultCode
ov_fopen : extern func (path: CString, vf: _OggFile*) -> OggResultCode
ov_open_callbacks: extern func (datasource: Pointer, vf: _OggFile*, initial: Pointer, ibytes: Long, callbacks: OggCallbacks) -> OggResultCode

ov_info : extern func (vf: _OggFile*, link: Int) -> VorbisInfo*
ov_read : extern func (vf: _OggFile*, buffer: Pointer, length: Int, bigendianp: Int, word: Int, signedness: Int, bitstream: Int*) -> Int
ov_clear: extern func (vf: _OggFile*)

// high-level binding

OggEndianness: enum from Int {
  LITTLE = 0
  BIG = 1
}

OggWordsize: enum from Int {
  WORD_8BIT = 1
  WORD_16BIT = 2
}

OggSignedness: enum from Int {
  UNSIGNED = 0
  SIGNED = 1
}

OggException: class extends Exception {

  init: super func

}

OggFile: class {

  _file: _OggFile
  info: VorbisInfo*
  endianness := OggEndianness LITTLE
  wordSize := OggWordsize WORD_16BIT
  signedness := OggSignedness SIGNED
  bitstream := -1

  init: func (path: String) {
    _errorHandling(ov_fopen(path, _file&))
    info = ov_info(_file&, -1)
  }

  read: func (buffer: Pointer, length: Int) -> Int {
    result := ov_read(_file&, buffer, length, endianness, wordSize, signedness, bitstream&)
    if (result < 0) {
      _errorHandling(result as OggResultCode)
    }
    result
  }

  setEndianness: func (=endianness)
  setWordSize: func (=wordSize)
  setSignedness: func (=signedness)

  clear: func {
    ov_clear(_file&)
  }

  _errorHandling: func (code: OggResultCode) {
    if (code < 0) {
      OggException new("libvorbisfile error: %s" format(code toString())) throw()
    }
  }

}

