// ignore_for_file: public_member_api_docs, sort_constructors_first
// login exception
class InvalidEmailAuthException implements Exception {}

class UserDiabledAuthException implements Exception {}

class UserNotFoundAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}

class WrongCredentialAuthException implements Exception {}

// register exception

class EmailAlreadyInUseAuthException implements Exception {}

class WeakPasswordAuthException implements Exception {}

class GenericAuthException implements Exception {}

class TooManyRequestAuthException implements Exception {}