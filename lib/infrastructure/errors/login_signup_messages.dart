enum LoginSignupMessages {
  success,
  weakPassword,
  emailAlreadyExists,
  userNotFound,
  invalidCredentials,
  tooManyAttempts,
  wrongPassword,
  unkownError
}

String getLoginSignupMessage(LoginSignupMessages mex) {
  switch (mex) {
    case LoginSignupMessages.success:
      return "L'operazione è stata completata con successo.";
    case LoginSignupMessages.weakPassword:
      return "La password è troppo debole. Riprova con una più complessa.";

    case LoginSignupMessages.emailAlreadyExists:
      return "L'indirizzo mail inserto è già esistente. Esegui il login invece.";

    case LoginSignupMessages.unkownError:
      return "Si è verificato un errore sconosciuto";

    case LoginSignupMessages.userNotFound:
      return "Non è stato trovato un utente con l'indirizzo email inserito.";

    case LoginSignupMessages.wrongPassword:
      return "Password errata per l'indirizzo email inserito.";
    case LoginSignupMessages.invalidCredentials:
      return "Credenziali invalide";
    case LoginSignupMessages.tooManyAttempts:
      return "Too many attempts. Wait a few minutes before retrying.";
  }
}
