sealed class Resource<T> {
  const Resource();
}

class ResourceSuccess<T> extends Resource<T> {
  final T data;
  const ResourceSuccess(this.data);
}

class ResourceError<T> extends Resource<T> {
  final String message;
  final int? errorCode; // Maybe we'll need that later
  const ResourceError(this.message, {this.errorCode});
}
