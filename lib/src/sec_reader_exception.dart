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
class SecReaderException implements Exception {
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

  /// Factory constructor that converts any exception to a [SecReaderException].
  ///
  /// If the exception is already a [SecReaderException], it returns it as-is.
  /// Otherwise, it creates a new [SecReaderException] with the exception's
  /// string representation as the message and [SecReaderExceptionType.unspecified]
  /// as the type.
  ///
  /// [exception] The exception to convert. Can be null.
  /// [fallbackMessage] An optional fallback message to use when [exception]
  /// is null. If both [exception] and [fallbackMessage] are null, a default
  /// message will be used.
  factory SecReaderException.from(
    dynamic exception, {
    String? fallbackMessage,
  }) {
    if (exception is SecReaderException) {
      return exception;
    }

    return SecReaderException(
      message: fallbackMessage ?? exception?.toString() ?? 'Unknown error',
    );
  }

  /// A message providing additional details about the SEC reader error.
  ///
  /// If not specified during the exception creation, a default message
  /// ("Unspecified SEC reader error") will be used.
  final String? message;

  /// The type of exception that was thrown.
  /// The default value is [SecReaderExceptionType.unspecified].
  final SecReaderExceptionType type;
}
