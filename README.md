# La Troupe Castor - Système d'Éligibilité aux Aides

Ce projet implémente un système de vérification d'éligibilité aux aides pour la rénovation énergétique.

## Algorithme d'Éligibilité

L'algorithme de vérification d'éligibilité (`functions/check_eligibility/eligibility.ts`) fonctionne en plusieurs étapes :

1. **Récupération des données**
   - Informations sur la simulation (profil utilisateur, type de travaux, etc.)
   - Liste des aides disponibles dans la base de données

2. **Filtrage des aides**
   Pour chaque aide, vérification des critères :
   - Revenus (minimum/maximum)
   - Âge du bâtiment
   - Statut d'occupation (propriétaire, locataire, etc.)
   - Types de travaux autorisés
   - Département (pour les aides locales)

3. **Calcul des montants**
   Pour chaque aide éligible :
   - Calcul du montant de base
   - Application des bonus (ex: matériaux biosourcés)
   - Ajustements selon la surface ou autres critères

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

Les migrations et seeds sont automatiquement appliqués par le workflow.

## Développement Local

1. Cloner le repository
   ```bash
   git clone [URL_DU_REPO]
   cd [NOM_DU_REPO]
   ```

2. Configurer l'environnement
   - Copier `.env.example` vers `.env`
   - Remplir les variables d'environnement

3. Lancer Supabase en local
   ```bash
   supabase start
   supabase db reset
   ```

4. Lancer les tests
   ```bash
   deno test --allow-env --allow-read --allow-net functions/tests/check_eligibility-test.ts
   ```

## Contribution

1. Créer une branche pour vos modifications
2. Ajouter ou modifier les tests si nécessaire
3. Vérifier que tous les tests passent
4. Créer une Pull Request

Les workflows GitHub s'exécuteront automatiquement sur votre PR.
