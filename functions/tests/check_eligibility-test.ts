import { assert } from 'https://deno.land/std@0.192.0/testing/asserts.ts'
import { createClient, SupabaseClient } from 'jsr:@supabase/supabase-js@2'
import { Simulation } from '../check_eligibility/types.ts'

// Load environment variables
import 'https://deno.land/x/dotenv@v3.2.2/load.ts'
import { checkEligibility } from "../check_eligibility/eligibility.ts";

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''

console.log('Supabase URL:', supabaseUrl)
console.log('Supabase Key:', supabaseKey)
const options = {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
    },
}

// Catégories de test pour organiser les assertions
const testCategories = {
    revenuTests: ['test-revenus-tres-modestes', 'test-revenus-modestes', 'test-revenus-eleves'],
    occupancyTests: ['test-proprietaire-bailleur', 'test-locataire', 'test-copropriete'],
    locationTests: ['test-hors-49', 'test-batiment-recent'],
    specialCases: ['test-tous-criteres-max-ancien', 'test-tous-criteres-max-recent']
};

// Test client creation and database connection
const testClientCreation = async () => {
    const client: SupabaseClient = createClient(supabaseUrl, supabaseKey, options)

    if (!supabaseUrl) throw new Error('supabaseUrl is required.')
    if (!supabaseKey) throw new Error('supabaseKey is required.')

    const { data: table_data, error: table_error } = await client
        .from('aid_details')
        .select('*')
        .limit(1)

    if (table_error) {
        throw new Error('Invalid Supabase client: ' + table_error.message)
    }

    assert(table_data, 'Data should be returned from the query.')
}

// Test the check_eligibility function with different scenarios
const testCheckEligibility = async () => {
    const client: SupabaseClient = createClient(supabaseUrl, supabaseKey, options)

    for (const category of Object.keys(testCategories)) {
        console.log(`\nTesting category: ${category}`)

        for (const sessionToken of testCategories[category as keyof typeof testCategories]) {
            console.log(`\nRunning test: ${sessionToken}`)

            try {
                // Récupérer la simulation depuis la base de données
                const { data: simulation, error: simError } = await client
                    .from('aid_simulation')
                    .select('*')
                    .eq('session_token', sessionToken)
                    .single()

                if (simError) throw new Error(`Failed to fetch simulation: ${simError.message}`)
                if (!simulation) throw new Error(`No simulation found for session token: ${sessionToken}`)

                const result = await checkEligibility(simulation, client)

                // Tests de base pour tous les cas
                assert(result, 'Result should not be null')
                assert(Array.isArray(result.eligible_aids), 'eligible_aids should be an array')
                assert(Array.isArray(result.additional_funding_options), 'additional_funding_options should be an array')
                assert(Array.isArray(result.available_aids_info), 'available_aids_info should be an array')

                // Tests spécifiques selon le cas
                switch (sessionToken) {
                    case 'test-revenus-tres-modestes':
                        assert(result.eligible_aids.length > 0, 'Should have eligible aids for very low income')
                        assert(result.eligible_aids.some(aid => aid.name === 'MaPrimeRenov'), 'Should include MaPrimeRenov')
                        assert(result.eligible_aids.some(aid =>
                            aid.name.includes('départementale') &&
                            aid.adjusted_amount > aid.default_amount
                        ), 'Should include department aid with biosourced bonus')
                        break;

                    case 'test-hors-49':
                        assert(!result.eligible_aids.some(aid =>
                            aid.name.includes('département') ||
                            aid.name.includes('Saumur') ||
                            aid.name.includes('Angers')
                        ), 'Should not include local aids for non-49 department')
                        break;

                    case 'test-locataire':
                        assert(result.eligible_aids.some(aid =>
                            aid.name === 'Certificats d\'Économies d\'Énergie'
                        ), 'Tenants should be eligible for CEE')
                        break;

                    case 'test-tous-criteres-max-ancien':
                        assert(result.eligible_aids.length > 0, 'Should have maximum eligible aids')
                        assert(result.eligible_aids.some(aid => aid.name === 'MaPrimeRenov'), 'Should include MaPrimeRenov')
                        assert(result.eligible_aids.some(aid => aid.name.includes('départementale')), 'Should include department aid')
                        break;

                    case 'test-tous-criteres-max-recent':
                        assert(result.eligible_aids.length > 0, 'Should have maximum eligible aids')
                        assert(result.eligible_aids.some(aid => aid.name === 'Certificats d\'Économies d\'Énergie'), 'Should include CEE')
                        break;
                }

                console.log(`Eligible aids count: ${result.eligible_aids.length}`)
                console.log('Eligible aids:', result.eligible_aids.map(aid => aid.name).join(', '))

            } catch (error) {
                console.error(`Error in test ${sessionToken}:`, error)
                throw error
            }
        }
    }
}

// Register the tests
Deno.test('Client Creation Test', testClientCreation)
Deno.test('Check Eligibility Tests', testCheckEligibility)
