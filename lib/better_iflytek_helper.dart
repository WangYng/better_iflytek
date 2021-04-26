import 'dart:async';
import 'dart:io';

class BetterIflytekHelper {
  static Future<void> pcmToWave({
    required String inputFile,
    required String outputFile,
    int numChannels = 1,
    int sampleRate = 16000,
  }) async {
    var filIn = File(inputFile);
    var filOut = File(outputFile);
    var size = filIn.lengthSync();
    IOSink sink = filOut.openWrite();

    var header = WaveHeader(
      WaveHeader.formatPCM,
      numChannels = numChannels, //
      sampleRate = sampleRate,
      16, // 16 bits per byte
      size, // total number of bytes
    );
    header.write(sink);
    await filIn.open();
    var buffer = filIn.readAsBytesSync();
    sink.add(buffer.toList());
    await sink.close();
  }
}

class WaveHeader {
  /// follows WAVE format in http://ccrma.stanford.edu/courses/422/projects/WaveFormat
  static final String tag = 'WaveHeader';

  ///
  static final int headerLength = 44;

  /// Indicates PCM format.
  static final int formatPCM = 1;

  /// Indicates ALAW format.
  static final int formatALAW = 6;

  /// Indicates ULAW format.
  static final int formatULAW = 7;

  ///
  int mFormat;

  ///
  int mNumChannels;

  ///
  int mSampleRate;

  ///
  int mBitsPerSample;

  ///
  int mNumBytes;

  /// Construct a WaveHeader, with fields initialized.
  ///
  /// @param format format of audio data,
  /// one of {@link #FORMAT_PCM}, {@link #FORMAT_ULAW}, or {@link #FORMAT_ALAW}.
  /// @param numChannels 1 for mono, 2 for stereo.
  /// @param sampleRate typically 8000, 11025, 16000, 22050, or 44100 hz.
  /// @param bitsPerSample usually 16 for PCM, 8 for ULAW or 8 for ALAW.
  /// @param numBytes size of audio data after this header, in bytes.
  ///
  WaveHeader(this.mFormat, this.mNumChannels, this.mSampleRate, this.mBitsPerSample, this.mNumBytes);

  /// Write a WAVE file header.
  ///
  /// @param out {@link java.io.OutputStream} to receive the header.
  /// @return number of bytes written.
  /// @throws IOException
  int write(EventSink<List<int>> out) {
    /* RIFF header */
    writeString(out, 'RIFF');
    writeInt32(out, 36 + mNumBytes);
    writeString(out, 'WAVE');
    /* fmt chunk */
    writeString(out, 'fmt ');
    writeInt32(out, 16);
    writeInt16(out, mFormat);
    writeInt16(out, mNumChannels);
    writeInt32(out, mSampleRate);
    writeInt32(out, (mNumChannels * mSampleRate * mBitsPerSample / 8).floor());
    writeInt16(out, (mNumChannels * mBitsPerSample / 8).floor());
    writeInt16(out, mBitsPerSample);
    /* data chunk */
    writeString(out, 'data');
    writeInt32(out, mNumBytes);

    return headerLength;
  }

  /// Push a String to the header
  static void writeString(EventSink<List<int>> out, String id) {
    out.add(id.codeUnits);
  }

  /// Push an int32 in the header
  static void writeInt32(EventSink<List<int>> out, int val) {
    out.add([val >> 0, val >> 8, val >> 16, val >> 24]);
  }

  /// Push an Int16 in the header
  static void writeInt16(EventSink<List<int>> out, int val) async {
    out.add([val >> 0, val >> 8]);
  }
}
