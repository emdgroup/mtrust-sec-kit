/// Enumerates the types of exceptions that can be thrown by the SEC reader.
enum SecReaderExceptionType {
  /// Firmware version installed on the device is incompatible
  incompatibleFirmware,

  /// Measurement failed
  measurementFailed,

  /// Failed to get or install new token
  tokenFailed,

  /// Failed to connect to a reader
  connectionFailed,

  /// A command sent to the reader failed or returned an unexpected response
  commandFailed,

  /// Unspecified error
  unspecified,
}

/// Exception thrown to indicate errors from the SEC reader.
///
/// All errors thrown by `SECReader` methods use this type, with a
/// [SecReaderExceptionType] to categorize the failure. Inside the widget UI,
/// the exception mapper translates these into localized exceptions for
/// display, preserving the original [SecReaderException] so that
/// `onVerificationFailed` callbacks can access the typed failure cause.
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

  /// Creates a [SecReaderException] from an arbitrary exception.
  ///
  /// If [exception] is already a [SecReaderException], it is returned as-is,
  /// preserving its [type]. Otherwise, a new instance is created with
  /// [SecReaderExceptionType.unspecified].
  ///
  /// The [fallbackMessage] is preferred over `exception.toString()` when
  /// creating a new instance. This is typically the localized error message
  /// produced by the exception mapper.
  ///
  /// Used by the widget layer to extract a [SecReaderException] from a
  /// mapped exception for the `onVerificationFailed` callback.
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
