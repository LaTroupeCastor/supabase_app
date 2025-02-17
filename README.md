# La Troupe Castor - Système d'Éligibilité aux Aides

Ce projet implémente un système de vérification d'éligibilité aux aides pour la rénovation énergétique.

## Algorithme d'Éligibilité

L'algorithme de vérification d'éligibilité (`functions/check_eligibility/eligibility.ts`) est conçu pour déterminer les aides disponibles pour un projet de rénovation énergétique. Voici son fonctionnement détaillé :

### 1. Récupération et Validation des Données

#### Données de Simulation
- Profil utilisateur (revenus, statut d'occupation)
- Caractéristiques du logement (âge, surface, étiquette énergétique)
- Type de travaux envisagés
- Localisation (département)
- Options spécifiques (matériaux biosourcés)

#### Données des Aides
- Catalogue complet des aides disponibles
- Critères d'éligibilité pour chaque aide
- Montants de base et bonus possibles

### 2. Processus de Filtrage

L'algorithme applique une série de filtres pour chaque aide. Les travaux peuvent maintenant être multiples, permettant de cumuler les aides et les montants pour différents types de travaux :

#### a. Filtres Primaires
- **Revenus** :
  - Vérification des seuils minimum/maximum
  - Prise en compte des tranches de revenus (très modeste, modeste, etc.)
  - Adaptation des montants selon la tranche

- **Âge du Bâtiment** :
  - Distinction entre bâtiments récents et anciens (seuil de 15 ans)
  - Critères spécifiques pour certaines aides (ex: MaPrimeRenov)

#### b. Filtres de Statut
- **Statut d'Occupation** :
  - Propriétaire occupant
  - Propriétaire bailleur
  - Locataire
  - Copropriétaire
  - Vérification des aides accessibles pour chaque statut

#### c. Filtres Techniques
- **Types de Travaux** :
  - Combinaisons possibles :
    * Isolation + Chauffage
    * Ventilation + Menuiseries
    * Isolation + Chauffage + Ventilation
    * etc.
  - Chaque type de travaux peut générer ses propres aides
  - Les montants CEE sont cumulables par type de travaux
  - Vérification de la compatibilité de chaque type avec les critères de l'aide

#### d. Filtres Géographiques
- **Département** :
  - Aides nationales (disponibles partout)
  - Aides locales (département 49)
  - Aides spécifiques (communes, agglomérations)

### 3. Calcul des Montants

Pour chaque aide éligible, l'algorithme effectue :

#### a. Calcul du Montant de Base
- Montant forfaitaire ou pourcentage
- Adaptation selon la tranche de revenus
- Prise en compte des plafonds

#### b. Application des Bonus
- **Bonus Matériaux Biosourcés** :
  - Vérification de l'utilisation
  - Calcul du bonus (+500€ pour certaines aides)

#### c. Ajustements Spécifiques
- **Surface** :
  - Calcul au m² si applicable
  - Application des coefficients
  - Respect des plafonds

- **Cumul des Aides** :
  - Vérification des règles de cumul
  - Respect des plafonds globaux
  - Optimisation des combinaisons

### 4. Résultats et Recommandations

L'algorithme retourne :

#### a. Aides Éligibles
- Liste détaillée des aides accessibles
- Montants calculés et ajustés
- Conditions spécifiques à respecter

#### b. Options de Financement
- Suggestions de prêts (Éco-PTZ)
- Autres dispositifs complémentaires
- Optimisations possibles

#### c. Informations Complémentaires
- Documents requis par aide
- Contacts des organismes
- Prochaines étapes recommandées

### 5. Validation et Tests

L'algorithme est validé par :
- Tests unitaires couvrant chaque cas
- Scénarios de test réels
- Vérifications des règles de cumul
- Tests de régression automatisés

### 6. Pseudo-code des Algorithmes

#### a. Vérification d'Éligibilité
```
Algorithme VerifierEligibilite
    // Entrées : simulation, client
    // Sortie : liste des aides éligibles avec montants

    DÉBUT
        // 1. Récupération des données
        aides ← RecupererToutesLesAides(client)
        trancheRevenu ← CalculerTrancheRevenu(simulation.revenuFiscal)
        aidesEligibles ← liste vide
        
        // 2. Filtrage des aides
        POUR CHAQUE aide DANS aides FAIRE
            eligible ← VRAI
            
            // 2.a Vérification des revenus
            SI aide.revenuMin ET trancheRevenu.min < aide.revenuMin ALORS
                eligible ← FAUX
            SI aide.revenuMax ET trancheRevenu.max > aide.revenuMax ALORS
                eligible ← FAUX
            
            // 2.b Vérification de l'âge du bâtiment
            SI aide.batimentPlusDe15Ans ≠ simulation.batimentPlusDe15Ans ALORS
                eligible ← FAUX
            
            // 2.c Vérification du statut d'occupation
            SI aide.statutsOccupationAutorises N'INCLUT PAS simulation.statutOccupation ALORS
                eligible ← FAUX
            
            // 2.d Vérification du type de travaux
            SI aide.typesTravauxAutorises ET aide.typesTravauxAutorises.longueur > 0 ET
               PAS (simulation.typeTravaux.EXISTE(type => aide.typesTravauxAutorises.INCLUT(type))) ALORS
                eligible ← FAUX
            
            // 2.e Vérification du département
            SI aide.departement ≠ NULL ET aide.departement ≠ simulation.departement ALORS
                eligible ← FAUX
            
            SI eligible ALORS
                AJOUTER aide À aidesEligibles
            
        FIN POUR
        
        // 3. Calcul des montants
        aidesCalculees ← liste vide
        
        POUR CHAQUE aide DANS aidesEligibles FAIRE
            // 3.a Calcul du montant de base
            montant ← aide.montantDefaut
            
            SELON aide.nom FAIRE
                CAS "CEE":
                    montant ← 0
                    POUR CHAQUE type DANS simulation.typeTravaux FAIRE
                        montant ← montant + BASE_CEE_AMOUNTS[type]
                    FIN POUR
                    
                    SI simulation.revenuFiscal = TRES_MODESTE ALORS
                        montant ← montant * 2
                    SINON SI simulation.revenuFiscal = MODESTE ALORS
                        montant ← montant * 1.5
                    FIN SI
                    
                CAS "MaPrimeRenov":
                    montant ← CalculerMontantMaPrimeRenov(simulation)
                // etc.
            FIN SELON
            
            // 3.b Application des bonus
            SI simulation.materiauxBiosources ET aide.nom CONTIENT "départementale" ALORS
                montant ← montant + 500
            FIN SI
            
            // 3.c Ajustements finaux
            montant ← AppliquerAjustements(montant, aide, simulation)
            
            AJOUTER {aide, montantAjuste: montant} À aidesCalculees
        FIN POUR
        
        // 4. Préparation du résultat
        RETOURNER {
            aidesEligibles: aidesCalculees,
            optionsFinancementSupp: ObtenirOptionsSupp(simulation),
            infoAidesDisponibles: ObtenirInfoAides(aidesCalculees)
        }
    FIN
```
#### b. Calcul du Montant de MaPrimeRenov
```
Algorithme TesterEligibilite
    // Entrées : client
    // Sortie : résultats des tests

    DÉBUT
        // 1. Initialisation
        categories ← {
            "TestsRevenus": ["test-revenus-tres-modestes", "test-revenus-modestes", "test-revenus-eleves"],
            "TestsOccupation": ["test-proprietaire-bailleur", "test-locataire", "test-copropriete"],
            "TestsLocalisation": ["test-hors-49", "test-batiment-recent"],
            "TestsSpeciaux": ["test-tous-criteres-max-ancien", "test-tous-criteres-max-recent"]
        }
        
        // 2. Exécution des tests par catégorie
        POUR CHAQUE categorie DANS categories FAIRE
            AFFICHER "Test de la catégorie : " + categorie
            
            POUR CHAQUE sessionToken DANS categories[categorie] FAIRE
                AFFICHER "Exécution du test : " + sessionToken
                
                // 2.a Récupération de la simulation
                simulation ← RecupererSimulation(client, sessionToken)
                SI simulation = NULL ALORS
                    LEVER ERREUR "Simulation non trouvée : " + sessionToken
                FIN SI
                
                // 2.b Exécution de la vérification
                resultat ← VerifierEligibilite(simulation, client)
                
                // 2.c Vérifications de base
                VERIFIER resultat ≠ NULL
                VERIFIER resultat.aidesEligibles EST UN TABLEAU
                
                // 2.d Vérifications spécifiques
                SELON sessionToken FAIRE
                    CAS "test-revenus-tres-modestes":
                        VERIFIER resultat.aidesEligibles.longueur > 0
                        VERIFIER resultat.aidesEligibles CONTIENT "MaPrimeRenov"
                        VERIFIER resultat.aidesEligibles CONTIENT AIDE DÉPARTEMENTALE AVEC BONUS
                    
                    CAS "test-hors-49":
                        VERIFIER resultat.aidesEligibles NE CONTIENT PAS AIDES LOCALES
                    
                    CAS "test-locataire":
                        VERIFIER resultat.aidesEligibles CONTIENT "CEE"
                    
                    CAS "test-tous-criteres-max-ancien":
                        VERIFIER resultat.aidesEligibles CONTIENT "MaPrimeRenov"
                        VERIFIER resultat.aidesEligibles CONTIENT AIDE DÉPARTEMENTALE
                    
                    CAS "test-tous-criteres-max-recent":
                        VERIFIER resultat.aidesEligibles CONTIENT "CEE"
                FIN SELON
                
                // 2.e Affichage des résultats
                AFFICHER "Nombre d'aides éligibles : " + resultat.aidesEligibles.longueur
                AFFICHER "Aides éligibles : " + resultat.aidesEligibles
            FIN POUR
        FIN POUR
    FIN
```

## Tests Automatisés

Les tests (`functions/tests/check_eligibility-test.ts`) vérifient différents scénarios :
- Profils de revenus (très modestes à élevés)
- Statuts d'occupation
- Types de travaux
- Localisation
- Cas particuliers

Chaque test utilise des données de simulation stockées en base de données, permettant de :
- Tester des cas réels
- Maintenir facilement les cas de test
- Vérifier la cohérence avec la base de données

## Workflow GitHub

Le projet utilise deux workflows GitHub :

### 1. Test Principal (`test-fonctions-eligibility.yml`)
Déclenché automatiquement sur :
- Push sur main
- Pull requests

Étapes :
1. Configuration de l'environnement
   - Installation de Deno
   - Installation de Supabase CLI
   - Configuration des variables d'environnement

2. Préparation de la base de données
   - Création de la structure Supabase
   - Copie des migrations et seeds
   - Initialisation de la base

3. Exécution des tests
   - Lancement des tests d'éligibilité
   - Vérification des différents scénarios

4. Notification en cas d'échec
   - Envoi d'email via SMTP OVH
   - Détails de l'erreur et lien vers les logs

### 2. Test de Notification (`test-error-notification.yml`)
Workflow manuel pour tester le système de notification :
- Simule un échec de test
- Vérifie l'envoi des notifications par email
- Utile pour valider la configuration SMTP

## Configuration Requise

### Variables d'Environnement
Secrets GitHub nécessaires :
```env
SUPABASE_URL=            # URL de votre projet Supabase
SUPABASE_ANON_KEY=       # Clé anonyme Supabase
SUPABASE_DB_PASSWORD=    # Mot de passe de la base de données
SUPABASE_PROJECT_REF=    # Référence du projet Supabase
SMTP_USERNAME=           # Adresse email OVH pour les notifications
SMTP_PASSWORD=           # Mot de passe SMTP OVH
```

### Base de Données
La base de données doit contenir :
- Table `aid_details` : définition des aides
- Table `aid_simulation` : données des simulations
