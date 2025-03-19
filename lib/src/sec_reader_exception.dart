/// Enumerates the types of exceptions that can be thrown by the SEC reader.
enum SecReaderExceptionType {
  /// Firmware version installed on the device is incompatible
  incompatibleFirmware,
  /// Measurement failed
  measurementFailed,
  /// Failed to get or install new token
  tokenFailed,
  /// Unspecified error
  unspecified,
}


/// Exception thrown to indicate errors related to the SEC reader.
///
/// This exception extends the [Error] class and is designed
/// to be used specifically for handling errors in the context of SEC
/// reading.
class SecReaderException extends Error {
  /// Creates a new instance of [SecReaderException].
  ///
  /// The [message] parameter can be used to provide additional details
  /// about the nature of the SEC reader error. If not specified,
  /// a default message will be used.
  /// The [type] parameter can be used to specify the type of exception.
  SecReaderException({
    this.message = 'Unspecified SEC reader error',
    this.type = SecReaderExceptionType.unspecified,
  });

  /// A message providing additional details about the SEC reader error.
  ///
  /// If not specified during the exception creation, a default message
  /// ("Unspecified SEC reader error") will be used.
  final String? message;
  /// The type of exception that was thrown. 
  /// The default value is [SecReaderExceptionType.unspecified].
  final SecReaderExceptionType? type;
}

/// Exception thrown when a SEC reader is not found.
class SecConnectionFailedException extends SecReaderException {
  /// Creates a new instance of [SecConnectionFailedException].
  SecConnectionFailedException()
      : super(message: 'SEC reader not found');
}
