// Les différentes Classes
class ClassPraticien {
  final String id;
  final String specialite, presentation, lieuTravail, heure,disponibilite;

  ClassPraticien({
    required this.id,
    required this.presentation,
    required this.specialite,
    required this.lieuTravail,
    required this.heure,
    required this.disponibilite
  });
}

class ClassUtilisateur {
  final String id;
  final String civilite,
      nom,
      prenom,
      dateNaissance,
      villeNaissance,
      villeResidence,
      telephone,
      type;
  final bool statusActiveted;

  ClassUtilisateur(
      {required this.id,
      required this.nom,
      required this.civilite,
      required this.prenom,
      required this.dateNaissance,
      required this.villeNaissance,
      required this.villeResidence,
      required this.telephone,
      required this.type,
      required this.statusActiveted});
}

class ClassConsultation {
  final String id;
  final String patientId,
      praticienId,
      date,
      heure,
      annee,
      diagnostic;

  ClassConsultation(
      {required this.id,
      required this.patientId,
      required this.praticienId,
      required this.date,
      required this.heure,
      required this.annee,
      required this.diagnostic,
      });
}

class ClassNote {
  final String id;
  final String PraticienId, message, date, heure;

  ClassNote({
    required this.id,
    required this.PraticienId,
    required this.message,
    required this.date,
    required this.heure,
  });
}