# Tests d'intégration avec Supabase

Notre suite de tests vérifie l'interaction entre notre logique d'éligibilité et la base de données Supabase à travers des scénarios utilisateurs pré-configurés.

## Préparation des données de test
Les scénarios sont injectés dans la base via des seeds SQL. Chaque scénario est identifié par un session_token unique et représente un cas d'usage spécifique. Les données couvrent un large éventail de situations : différents profils de revenus, statuts d'occupation et types de logement.

Exemple de structure des scénarios :
```typescript
const testCategories = {
    revenuTests: ['test-revenus-tres-modestes', 'test-revenus-modestes', 'test-revenus-eleves'],
    occupancyTests: ['test-proprietaire-bailleur', 'test-locataire', 'test-copropriete'],
    specialCases: ['test-tous-criteres-max-ancien', 'test-tous-criteres-max-recent']
};
```

## Scénarios utilisateurs testés
Nos tests couvrent plusieurs catégories de profils utilisateurs. Pour chaque profil, nous vérifions des cas spécifiques. Par exemple, pour un propriétaire avec tous les critères maximaux dans un logement ancien :

```typescript
case 'test-tous-criteres-max-ancien':
    assert(result.eligible_aids.length > 0, 'Should have maximum eligible aids')
    assert(result.eligible_aids.some(aid => aid.name === 'MaPrimeRenov'), 'Should include MaPrimeRenov')
    assert(result.eligible_aids.some(aid => aid.name.includes('départementale')), 'Should include department aid')
    break;
```

Pour un ménage à très faibles revenus :
```typescript
case 'test-revenus-tres-modestes':
    assert(result.eligible_aids.some(aid => aid.name === 'MaPrimeRenov'), 'Should include MaPrimeRenov')
    assert(result.eligible_aids.some(aid => aid.name === 'Certificats d\'Économies d\'Énergie'), 'Should include CEE')
    const ceeAid = result.eligible_aids.find(aid => aid.name === 'Certificats d\'Économies d\'Énergie')
    assert(ceeAid && ceeAid.adjusted_amount > 0, 'CEE amount should be positive')
    break;
```

## Vérifications effectuées
Pour chaque scénario, notre système valide l'ensemble du processus : la récupération des données depuis Supabase, le calcul des aides selon le profil, l'ajustement des montants selon les critères spécifiques, et la présence des aides attendues.

Exemple de vérification de la connexion à la base de données :
```typescript
const testClientCreation = async () => {
    const client: SupabaseClient = createClient(supabaseUrl, supabaseKey, options)
    const { data: table_data, error: table_error } = await client
        .from('aid_details')
        .select('*')
        .limit(1)
    assert(table_data, 'Data should be returned from the query.')
}
```

Ces tests garantissent que chaque profil utilisateur obtient des résultats d'éligibilité correspondant exactement à sa situation, en vérifiant l'ensemble du parcours depuis la base de données jusqu'à la réponse finale.
