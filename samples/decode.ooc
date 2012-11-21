use vorbis
import vorbis

import io/FileWriter

main: func {

  file := OggFile new("plop.ogg")

  "Opened file, %s endian, %s words, %s" printfln(
    file endianness == OggEndianness LITTLE ? "little" : "big",
    file wordSize == OggWordsize WORD_8BIT ? "8bit" : "16bit",
    file signedness == OggSignedness UNSIGNED ? "unsigned" : "signed"
  )
  "rate = %d, channels = %d" printfln(file info@ rate, file info@ channels)

  buffer := Buffer new(32_768) // 32KB buffer
  out := FileWriter new("plop.raw")
  
  while (true) {
    nbytes := file read(buffer data, buffer capacity) 
    if (nbytes > 0) {
      out write(buffer data, nbytes)
    } else {
      break
    }
  }

  file clear()
  out close()

}

