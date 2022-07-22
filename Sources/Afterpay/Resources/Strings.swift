//
//  Strings.swift
//  Afterpay
//
//  Created by Adam Campbell on 12/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let localeLanguages: [Locale: Strings] = [
  Locales.enAU: .en,
  Locales.enGB: .en,
  Locales.enNZ: .en,
  Locales.enUS: .en,
  Locales.enCA: .en,
  Locales.frCA: .frCA,
  Locales.frFR: .fr,
  Locales.itIT: .it,
  Locales.esES: .es,
]

// These should be transitioned to a `.strings` file once resource support is available for
// swift packages
enum Strings {

  case en
  case frCA
  case fr
  case it
  case es

  internal static func forLocale() -> Strings {
    return localeLanguages[Afterpay.language ?? Locales.enAU] ?? .en
  }

  internal var localised: LocalisedString {
    switch self {
    case .en:
      return LocalisedString(
        moreInfo: "More Info",
        orPayWith: "or pay with",
        learnMore: "Learn More",
        outsideLimitsTemplate: "available for orders between %1$@ – %2$@",
        availableTemplate: "%1$@ %2$@ %3$@payments of %4$@ %5$@",
        interestFree: "interest-free ",
        with: "with",
        intro: LocalisedIntroString(
          make: "make",
          makeTitle: "Make",
          pay: "pay",
          payTitle: "Pay",
          in: "in",
          inTitle: "In",
          or: "or",
          orTitle: "Or",
          payIn: "pay in",
          payInTitle: "Pay in"
        ),
        alert: LocalisedAlertString(
          cancelAction: "Cancel",
          yesAction: "Yes",
          noAction: "No",
          retryAction: "Retry",
          errorTitle: "Error",
          cancelPaymentTitle: "Are you sure you want to cancel the payment?",
          failedToLoadMessage: "Failed to load %@ checkout"
        )
      )
    case .frCA:
      return LocalisedString(
        moreInfo: "Plus d'infos",
        orPayWith: "ou payer avec",
        learnMore: "En savoir plus",
        outsideLimitsTemplate: "disponible pour les montants entre %1$@ – %2$@",
        availableTemplate: "%1$@ %2$@ paiements %3$@de %4$@ %5$@",
        interestFree: "sans intérêts ",
        with: "avec",
        intro: LocalisedIntroString(
          make: "effectuez",
          makeTitle: "Effectuez",
          pay: "payez",
          payTitle: "Payez",
          in: "en",
          inTitle: "En",
          or: "ou",
          orTitle: "Ou",
          payIn: "payez en",
          payInTitle: "Payez en"
        ),
        alert: LocalisedAlertString(
          cancelAction: "Annuler",
          yesAction: "Oui",
          noAction: "Non",
          retryAction: "Retenter",
          errorTitle: "Erreur",
          cancelPaymentTitle: "Êtes-vous sûr de vouloir annuler le paiement ?",
          failedToLoadMessage: "Échec du chargement de la caisse %@"
        )
      )
    case .fr:
      return LocalisedString(
        moreInfo: "Plus d'infos",
        orPayWith: "ou payer avec",
        learnMore: "En savoir plus",
        outsideLimitsTemplate: "disponible pour les montants entre %1$@ – %2$@",
        availableTemplate: "%1$@ %2$@ paiements %3$@de %4$@ %5$@",
        interestFree: "sans frais ",
        with: "avec",
        intro: LocalisedIntroString(
          make: "effectuez",
          makeTitle: "Effectuez",
          pay: "payez",
          payTitle: "Payez",
          in: "en",
          inTitle: "En",
          or: "ou",
          orTitle: "Ou",
          payIn: "payez en",
          payInTitle: "Payez en"
        ),
        alert: LocalisedAlertString(
          cancelAction: "Annuler",
          yesAction: "Oui",
          noAction: "Non",
          retryAction: "Réessayer",
          errorTitle: "Erreur",
          cancelPaymentTitle: "Êtes-vous sûr de vouloir annuler le paiement ?",
          failedToLoadMessage: "Échec du chargement de la page de paiement %@"
        )
      )
    case .it:
      return LocalisedString(
        moreInfo: "Maggiori info",
        orPayWith: "o paga con",
        learnMore: "Scopri di piú",
        outsideLimitsTemplate: "disponibile per importi fra %1$@ – %2$@",
        availableTemplate: "%1$@ %2$@ rate %3$@da %4$@ %5$@",
        interestFree: "senza interessi ",
        with: "con",
        intro: LocalisedIntroString(
          make: "scegli",
          makeTitle: "Scegli",
          pay: "paga",
          payTitle: "Paga",
          in: "in",
          inTitle: "In",
          or: "o",
          orTitle: "O",
          payIn: "paga in",
          payInTitle: "Paga in"
        ),
        alert: LocalisedAlertString(
          cancelAction: "Annulla",
          yesAction: "Si",
          noAction: "No",
          retryAction: "Riprovare",
          errorTitle: "Errore",
          cancelPaymentTitle: "Sei sicuro di voler annullare il pagamento?",
          failedToLoadMessage: "Impossibile caricare il cassa di %@"
        )
      )
    case .es:
      return LocalisedString(
        moreInfo: "Más infos",
        orPayWith: "o pagar con",
        learnMore: "Saber más",
        outsideLimitsTemplate: "disponible para importes entre %1$@ – %2$@",
        availableTemplate: "%1$@ %2$@ pagos %3$@de %4$@ %5$@",
        interestFree: "sin coste ",
        with: "con",
        intro: LocalisedIntroString(
          make: "haga",
          makeTitle: "Haga",
          pay: "paga",
          payTitle: "Paga",
          in: "en",
          inTitle: "En",
          or: "o",
          orTitle: "O",
          payIn: "paga en",
          payInTitle: "Paga en"
        ),
        alert: LocalisedAlertString(
          cancelAction: "Cancelar",
          yesAction: "Sí",
          noAction: "No",
          retryAction: "Volver a intentar",
          errorTitle: "Error",
          cancelPaymentTitle: "¿Estás seguro de que quieres anular el pago?",
          failedToLoadMessage: "Imposible cargar la página de pago de %@"
        )
      )
    }
  }

  // MARK: - Static Strings

  static let circledInfoIcon = "\u{24D8}"

  // MARK: - Accessible Strings

  static let accessibleAfterpay = "after pay"
  static let accessibleClearpay = "clear pay"

}

internal struct LocalisedIntroString {
  let make: String
  let makeTitle: String
  let pay: String
  let payTitle: String
  let `in`: String
  let inTitle: String
  let or: String
  let orTitle: String
  let payIn: String
  let payInTitle: String
}

internal struct LocalisedAlertString {
  let cancelAction: String
  let yesAction: String
  let noAction: String
  let retryAction: String
  let errorTitle: String
  let cancelPaymentTitle: String
  let failedToLoadMessage: String
}

internal struct LocalisedString {
  let moreInfo: String
  let orPayWith: String
  let learnMore: String
  let outsideLimitsTemplate: String
  let availableTemplate: String
  let interestFree: String
  let with: String
  let intro: LocalisedIntroString
  let alert: LocalisedAlertString
}
