import { assert, assertEquals } from 'https://deno.land/std@0.192.0/testing/asserts.ts'
import { createClient, SupabaseClient } from '@supabase/supabase-js'
import { Simulation, EligibilityResponse } from '../check_eligibility/types.ts'

// Load environment variables
import 'https://deno.land/x/dotenv@v3.2.2/load.ts'

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
const supabaseKey = Deno.env.get('SUPABASE_ANON_KEY') ?? ''
const options = {
    auth: {
        autoRefreshToken: false,
        persistSession: false,
        detectSessionInUrl: false,
    },
}

const testSimulations = {
    // Tests des différents profils de revenus
    revenuTests: [
        {
            id: "test-revenus-tres-modestes",
            fiscal_income: "very_low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "global_renovation",
            energy_label: "F",
            living_area: 100,
            biosourced_materials: true
        },
        {
            id: "test-revenus-modestes",
            fiscal_income: "low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "isolation",
            energy_label: "E",
            living_area: 85,
            biosourced_materials: false
        },
        {
            id: "test-revenus-eleves",
            fiscal_income: "very_high",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "heating",
            energy_label: "D",
            living_area: 150,
            biosourced_materials: false
        }
    ],

    // Tests des différents statuts d'occupation
    occupancyTests: [
        {
            id: "test-proprietaire-bailleur",
            fiscal_income: "medium",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_lessor",
            work_type: "global_renovation",
            energy_label: "F",
            living_area: 120,
            biosourced_materials: false
        },
        {
            id: "test-locataire",
            fiscal_income: "low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "tenant",
            work_type: "ventilation",
            energy_label: "E",
            living_area: 70,
            biosourced_materials: false
        },
        {
            id: "test-copropriete",
            fiscal_income: "medium",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "co_owner",
            work_type: "windows",
            energy_label: "D",
            living_area: 65,
            biosourced_materials: false
        }
    ],

    // Tests des différents types de travaux
    workTypeTests: [
        {
            id: "test-isolation",
            fiscal_income: "medium",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "isolation",
            energy_label: "E",
            living_area: 90,
            biosourced_materials: true
        },
        {
            id: "test-chauffage",
            fiscal_income: "medium",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "heating",
            energy_label: "F",
            living_area: 110,
            biosourced_materials: false
        },
        {
            id: "test-ventilation",
            fiscal_income: "low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "ventilation",
            energy_label: "D",
            living_area: 75,
            biosourced_materials: false
        }
    ],

    // Tests géographiques
    locationTests: [
        {
            id: "test-hors-49",
            fiscal_income: "medium",
            department: "44",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "global_renovation",
            energy_label: "F",
            living_area: 95,
            biosourced_materials: true
        },
        {
            id: "test-saumur",
            fiscal_income: "low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "windows",
            energy_label: "E",
            living_area: 85,
            biosourced_materials: false
        }
    ],

    // Tests cas particuliers
    specialCases: [
        {
            id: "test-batiment-recent",
            fiscal_income: "medium",
            department: "49",
            building_age_over_15: false,
            occupancy_status: "owner_occupant",
            work_type: "global_renovation",
            energy_label: "C",
            living_area: 130,
            biosourced_materials: false
        },
        {
            id: "test-grande-surface",
            fiscal_income: "high",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "isolation",
            energy_label: "E",
            living_area: 200,
            biosourced_materials: true
        },
        {
            id: "test-tous-criteres-max",
            fiscal_income: "very_low",
            department: "49",
            building_age_over_15: true,
            occupancy_status: "owner_occupant",
            work_type: "global_renovation",
            energy_label: "F",
            living_area: 120,
            biosourced_materials: true
        }
    ]
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

    for (const category in testSimulations) {
        console.log(`\nTesting category: ${category}`)
        for (const simulation of testSimulations[category]) {
            console.log(`\nRunning test: ${simulation.id}`)
            try {
                const result = await checkEligibility(simulation as Simulation, client)
                
                // Basic structure tests
                assert(result, 'Result should not be null')
                assert(Array.isArray(result.eligible_aids), 'eligible_aids should be an array')
                assert(Array.isArray(result.additional_funding_options), 'additional_funding_options should be an array')
                assert(Array.isArray(result.available_aids_info), 'available_aids_info should be an array')

                // Specific tests based on simulation type
                switch (simulation.id) {
                    case 'test-revenus-tres-modestes':
                        assert(result.eligible_aids.length > 0, 'Should have eligible aids for very low income')
                        assert(result.eligible_aids.some(aid => aid.name === 'MaPrimeRenov'), 'Should include MaPrimeRenov')
                        break;
                    
                    case 'test-hors-49':
                        assert(!result.eligible_aids.some(aid => 
                            aid.name.includes('département') || 
                            aid.name.includes('Saumur') || 
                            aid.name.includes('Angers')
                        ), 'Should not include local aids for non-49 department')
                        break;

                    case 'test-locataire':
                        assert(result.eligible_aids.some(aid => aid.name === 'Certificats d\'Économies d\'Énergie'), 
                            'Tenants should be eligible for CEE')
                        break;

                    // Add more specific test cases as needed
                }

                console.log(`Eligible aids count: ${result.eligible_aids.length}`)
                console.log('Eligible aids:', result.eligible_aids.map(aid => aid.name))
            } catch (error) {
                console.error(`Error in test ${simulation.id}:`, error)
                throw error
            }
        }
    }
}

// Register the tests
Deno.test('Client Creation Test', testClientCreation)
Deno.test('Check Eligibility Tests', testCheckEligibility)
