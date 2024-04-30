part of 'import_url_cubit.dart';

enum ImportURLStatus {
  ready,
  loading,
  error,
}

class ImportURLState extends Equatable {
  const ImportURLState({
    required this.status,
    required this.includeTags,
    required this.urlIsValid,
    this.errorMessage,
    this.url,
  });

  final ImportURLStatus status;
  final bool includeTags;
  final bool urlIsValid;
  final String? errorMessage;
  final String? url;

  ImportURLState copyWith({
    ImportURLStatus? status,
    bool? includeTags,
    bool? urlIsValid,
    String? errorMessage,
    String? url,
  }) {
    return ImportURLState(
      status: status ?? this.status,
      includeTags: includeTags ?? this.includeTags,
      urlIsValid: urlIsValid ?? this.urlIsValid,
      errorMessage: errorMessage ?? this.errorMessage,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [
        status,
        includeTags,
        urlIsValid,
        errorMessage,
        url,
      ];
}
